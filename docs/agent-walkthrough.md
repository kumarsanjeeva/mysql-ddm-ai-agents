# Agent walkthrough

File: `agent/support_agent.py`. No LLM is called. It is a fixed script.
It acts like a support agent and shows what a model would be given.

## Who it connects as

It connects as `ddv_agent`. The login details sit in `.local/agent.cnf`.
The script never prints them. The database masks sensitive columns for this user.

## The functions

- `connect()` opens the database connection. It reads the option file.
- `run(conn, sql, params)` runs one query. Values go in as parameters, never pasted into the text. It returns rows as dictionaries.
- `find_customer(name)` finds a customer by exact full name. It returns id, name, phone, email and tax id. Most of those come back masked.
- `list_orders(customer_id)` lists that customer's orders.
- `payment_status(order_id)` returns the payment for an order. It shows method, card, UPI, payment status and order status.
- `verify_last4(customer_id, last4)` asks the database if the last four phone digits match. It uses `RIGHT(phone, 4)`. The answer is 1 or 0.
- `ticket_notes(customer_id)` returns the ticket subject and free-text notes.
- `q1` to `q4` each hold one fixed question. Each makes a list of tool calls and returns the results.
- `build_context(question, calls)` turns one question and its results into plain text. That text is what a model would receive.
- `main()` runs all four questions. It prints to the console. It writes the context text to `evidence/21-llm-context.txt`.

## The four questions

1. Where is order 102? Find Asha, list her orders, check payment for 102.
2. Verify caller Asha with last four 0101. Find Asha, then compare the digits.
3. Why did Chen's charge fail? Find Chen, list orders, check each payment, read ticket notes.
4. Refund status of order 104? Check payment for 104.

## Data flow

1. The script asks the database a question as `ddv_agent`.
2. The database applies masking policies before it returns rows.
3. The script gets masked values only, such as `****0101`.
4. `build_context` puts those values into one text block.
5. That block is the model's context. Nothing is sent anywhere.

## The catch

Masking covers columns. It does not cover free text.
Ticket notes are a free-text column. A customer can type anything in them.
So a card number or email typed in a note comes back unmasked.
That is why the context text is scanned in the next step.
