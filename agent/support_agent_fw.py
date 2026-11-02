"""Scripted support agent. No LLM is called. It runs fixed tool calls and
builds the text a model WOULD receive as context."""
import os
import mysql.connector

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CNF = os.path.join(ROOT, ".local", "agent.cnf")      # credentials live here only
CONTEXT_FILE = os.path.join(ROOT, "evidence", "53-fw-llm-context.txt")


def connect():
    """Open a connection as ddv_agent using the option file. Prints no credentials."""
    return mysql.connector.connect(option_files=CNF, option_groups=["client"])


def run(conn, sql, params):
    """Run one parameterised query and return all rows as dictionaries."""
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params)
    rows = cur.fetchall()
    cur.close()
    return rows


def find_customer(conn, name):
    """Look up customers by exact full name."""
    return run(conn, "SELECT id, full_name, phone, email, tax_id "
                     "FROM ddv_support.customers WHERE full_name = %s", (name,))


def list_orders(conn, customer_id):
    """List all orders that belong to one customer."""
    return run(conn, "SELECT id, status, total_amount, created_at "
                     "FROM ddv_support.orders WHERE customer_id = %s ORDER BY id",
               (customer_id,))


def payment_status(conn, order_id):
    """Return the payment rows (method, card, UPI, status) for one order."""
    return run(conn, "SELECT p.id, p.order_id, p.method, p.card_number, p.upi_id, "
                     "p.status, o.status AS order_status "
                     "FROM ddv_support.payments p JOIN ddv_support.orders o "
                     "ON o.id = p.order_id WHERE p.order_id = %s", (order_id,))


def verify_last4(conn, customer_id, last4):
    """Check if the last four phone digits match. Returns a yes/no row."""
    return run(conn, "SELECT RIGHT(phone, 4) = %s AS matches "
                     "FROM ddv_support.customers WHERE id = %s", (last4, customer_id))


def ticket_notes(conn, customer_id):
    """Return the support ticket subject and free-text notes for one customer."""
    return run(conn, "SELECT id, subject, notes FROM ddv_support.support_tickets "
                     "WHERE customer_id = %s ORDER BY id", (customer_id,))


def q1(conn):
    """Where is order 102? Find the customer, list orders, check payment."""
    c = find_customer(conn, "Asha Example")
    return [("find_customer('Asha Example')", c),
            ("list_orders(%s)" % c[0]["id"], list_orders(conn, c[0]["id"])),
            ("payment_status(102)", payment_status(conn, 102))]


def q2(conn):
    """Verify caller Asha Example with last four 0101."""
    c = find_customer(conn, "Asha Example")
    return [("find_customer('Asha Example')", c),
            ("verify_last4(%s, '0101')" % c[0]["id"],
             verify_last4(conn, c[0]["id"], "0101"))]


def q3(conn):
    """Why did Chen Demo's charge fail? Orders, payments, and ticket notes."""
    c = find_customer(conn, "Chen Demo")
    cid = c[0]["id"]
    orders = list_orders(conn, cid)
    calls = [("find_customer('Chen Demo')", c), ("list_orders(%s)" % cid, orders)]
    for o in orders:
        calls.append(("payment_status(%s)" % o["id"], payment_status(conn, o["id"])))
    calls.append(("ticket_notes(%s)" % cid, ticket_notes(conn, cid)))
    return calls


def q4(conn):
    """Refund status of order 104."""
    return [("payment_status(104)", payment_status(conn, 104))]


QUESTIONS = [("Where is order 102?", q1),
             ("Verify caller Asha Example with last four 0101", q2),
             ("Why did Chen Demo's charge fail?", q3),
             ("What is the refund status of order 104?", q4)]


def build_context(question, calls):
    """Build the exact text a model would get: question, then each tool result."""
    lines = ["SYSTEM: You are a support agent. Answer using only the tool results.",
             "USER QUESTION: " + question, "TOOL RESULTS:"]
    for call, rows in calls:
        lines.append("- " + call + " -> %d row(s)" % len(rows))
        for r in rows:
            lines.append("    " + ", ".join("%s=%s" % (k, v) for k, v in r.items()))
    return "\n".join(lines)


def main():
    """Run the four questions, print console output, write the context file."""
    conn = connect()
    out = ["HEADER: NO LLM IS CALLED. This is the text a model WOULD receive as",
           "context for each question. Produced by agent/support_agent.py as ddv_agent.",
           ""]
    for n, (question, fn) in enumerate(QUESTIONS, 1):
        print("=== Question %d: %s" % (n, question))
        calls = fn(conn)
        for call, rows in calls:
            print("tool call: %s -> %d row(s)" % (call, len(rows)))
            for r in rows:
                print("    %s" % r)
        out.append("##### CONTEXT FOR QUESTION %d #####" % n)
        out.append(build_context(question, calls))
        out.append("")
    conn.close()
    with open(CONTEXT_FILE, "w", newline="\n") as f:
        f.write("\n".join(out))
    print("context written to evidence/21-llm-context.txt")


if __name__ == "__main__":
    main()
