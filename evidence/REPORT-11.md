# REPORT-11: Step 8, ALTER, inference probes, Firewall DETECTING and scoping, Audit passwords and accounts

Step 8: (A) ALTER TABLE without the MASKING POLICY clause by an account with ALTER but no MANAGE_DATA_MASKING_POLICY, on `ddv_probe4.probe_alter`; (B) twelve inference statements as `ddv_agent` and `ddv_billing` on `ddv_probe4.probe_people`; (C) Firewall (schema `ddv_sec`): allowed shape with other values, injection-style text, an enlisted-less account, a second group `fw_norole`, DETECTING mode; (D) Audit (schema `mysql`): filters for two accounts, a root filter with fake sentinel passwords; (E) cleanup and compare.

Every capture is `mysql --table -vvv --force` through cmd with stdout and stderr (2>&1); ERROR lines are in the files. Statement files `sql/81-NN.sql` are shared by both users. Scripts reused from earlier steps: `sql/53-*.sql`, `sql/60-audit-status.sql`, `sql/61-outofworkflow-N.sql`, `sql/70-snapshot.sql`, `sql/71-fw-status.sql`, `sql/73-precheck.sql`, `sql/73-drop-schema.sql`. Install and uninstall scripts for both components come from the server share folder and are not copied.

Disclosed: (1) The `CREATE USER ... IDENTIFIED BY` for `ddv_alterer` ran from a gitignored file with the client echo off, so it is not in any capture. (2) `evidence/82-norole-find-customer.txt` ends with `ERROR 2014 (HY000): Commands out of sync`; it is shown as captured and was not worked around. (3) DETECTING mode wrote nothing to `performance_schema.error_log` at `log_error_verbosity` 2; I did not change the verbosity (`evidence/82-error-log.txt`). (4) `evidence/84-compare.txt` lists one difference: the processlist row of the capturing session (connection id and port). (5) `evidence/82-recording-run.txt` and `evidence/82-ctx.txt` come from the RECORDING run of `agent/support_agent_step8.py`.

The raw Audit JSON (`.local/audit-raw-step8.json`) held a local path, the machine name and the OS user name and is not in the repo.

## SHA-256 (full), new files in sql/, agent/ and evidence/

```
c9e581949c520b45859e43d4835e6a2a11c123472e7ae67c4133feec5ef02b87  agent/support_agent_step8.py
29b23d0f107364424f6b522cf38a5db631e37cf12b2e1041ef6557ee405b467a  evidence/80-a1-after.txt
48a263eb24cf90d73ac9bba9fc799450c88b2ebc5a01a65aca70cc2f22424345  evidence/80-a1-stmt.txt
2ab461ccc4ad54775183299ed359a76b060f78f3a7c7d7d83b1b0deb832cebb0  evidence/80-a2-root-reattach.txt
3bf54be0679a675932368b0f357f3dffc5213ae76d662b3a3f7c9fea7fa6c955  evidence/80-a3-after.txt
abb1a730dea355bdfe850da38943d1bd6ef2354d5dd81a3d51d97bab92cc3998  evidence/80-a3-stmt.txt
5a92bc6d03eb2c2193e3f6817be6d4270c27c4495b725afbf22e84ff01949b07  evidence/80-a4-after.txt
126bd7a3c465321781eb3609cb8e559965649823d8d62b3fc7878cae328597cd  evidence/80-a4a-stmt.txt
7b0e946b4745045a5040c26fe27bb0f79b2c379451514126c678e0d49e090d3e  evidence/80-a4b-stmt.txt
1b26aea371a3aa2f4d7ba17b97c492cd5c82f9dc5562b47f52fff659db4da1b6  evidence/80-a4c-stmt.txt
59ae220c8b90bb5157aea80d0ca127ca0b74b300196f28f7b21d5c89fcd177ea  evidence/80-a4-root-restore.txt
13e8992e26060a94ad91e483f3b46eedcd1db1069319dbd11a9df33ff647e524  evidence/80-a5-after.txt
be9a42aa98c24685494670f4e6d0d0a92d97b37f03f810c68a2b0c90a4844619  evidence/80-a5-root-restore.txt
642cda8746b44eae1f0094428e635733b5d9b319f65de5364e4c9f50a69ca822  evidence/80-a5-stmt.txt
500147a19085b1c57eb240c2a198ca885472e9097b01ba3fee9b56b3ef0bcf6c  evidence/80-a-setup-root.txt
29523be2378cc2acc386d0fe67e3fb916fce7d2b8de066a3abbafb81ca3efa08  evidence/80-baseline.txt
5ad6ec5128a3eb8436b514e7d25f6d02d96cd551fcd8033311753b9e70e3b886  evidence/81-agent-01.txt
4c8cc9fd67cffc129e84ca9ffc96441dd61b79328e8922c5d4118decfd734c91  evidence/81-agent-02.txt
ff2b95ab33417266179bf4c2fe1a2204fa6ef370d3b0d99f53169d2bb7eaf203  evidence/81-agent-03.txt
e1b74cf59eda80d2388be6f28e83b58acfcb0bee74cedba096b6fa9cbe2fc502  evidence/81-agent-04.txt
363b8dec5f8dc6a770663aedc26ebaa7982f6c42b144f54877033f933e2c92ff  evidence/81-agent-05.txt
48a387a88d266cbbc3467d3ae7da75badc2f22037cb8bc7399616835e50f13dc  evidence/81-agent-06.txt
f593bd836aa5896b81198c66a40d2715cccbae08d30fa774d1c3735c865cf7cc  evidence/81-agent-07.txt
64681f3476a2e7d403f39517f2a295669444029e37bbc23cc23a0c4343c4c167  evidence/81-agent-08.txt
5c33da2653e516a9abb472ac45df2bdde82b7f574f251c43aaafdbc2bc7f380e  evidence/81-agent-09.txt
f3309b44aa2ead97d8d6a5e3595fa3cbfbb15c5a71d765b7aa304ddc100e0fdc  evidence/81-agent-10.txt
e0c180edce162bc910171f8a2cd014c3366126fbe2511edc0822dfdf83f4df58  evidence/81-agent-11.txt
d9cbb10328b5b29f90f6c3585c342e7073ddb0b809a8db8fbda0665967162e5a  evidence/81-agent-12.txt
5e13726ce075e2b56c89da2f4c3a30734e1a73bf5190d06b7d80eaf6da459e96  evidence/81-billing-01.txt
043a977280b0ec4ffe356fe3066a36f41aae62cc77d4462840feddb5ceb54221  evidence/81-billing-02.txt
1451aec95089d6865e3b5b972fda8d74bc508b79b7cb1792e3bd5fb1026f07e6  evidence/81-billing-03.txt
2d81398d60f1503d55ec936280d49e5075b19e5444dc59db9bd2ec5078c5500b  evidence/81-billing-04.txt
4b18e8db09e5e2fa329c4460223648fcbb581c7195b7a29539c3888e44ed5c96  evidence/81-billing-05.txt
0dbb3729ca67f0157f45a9d1d00092a74664876410554918dc8d6e5b0f09d305  evidence/81-billing-06.txt
7282be9e52638af848270d4e31a60958a624c189aefdcc83fabc7651c52651f8  evidence/81-billing-07.txt
b8cca7a4d8f67b20435f2f1b01a8ae7e0cb766ab8b64bb9aa0a433ad68a140f9  evidence/81-billing-08.txt
8e2a7d9c745fba224ccecb2ed7122c14850e719c66bd6ec99e8e2366c35c6144  evidence/81-billing-09.txt
802445ad5314ec32a8d91d2bc207d7ad8b32e046656a31981b2bef989dfaea55  evidence/81-billing-10.txt
66ae024e090a58a3e881496181d83922e0361b2a41290aed543268950f72b7f2  evidence/81-billing-11.txt
24e451f4b93ad97ba0609f677243f448056af81f4d0ce740e15af5e70d68d727  evidence/81-billing-12.txt
eeaf769063aa75b73e5180dde05ba7d5d5b1c87b78af36da2beca2b2ecbaedb4  evidence/81-setup-root.txt
9fad83853505e7a61a378ceb8e99e1ad4ff1c8f8b63e4dc054e309946c68c9db  evidence/82-agent-count-orders.txt
a6b2d19f7cba4f6cd332ceddbd96f30dc7664ef1b6fd1b3d93a05ba0df571611  evidence/82-agent-count-orders-status-after.txt
0db34490d2398cd594a9e9aba0d7bc714aed343c17c1505e5ee7519c4edf8da0  evidence/82-agent-count-orders-status-before.txt
ce343e4d4aa25e6c09d68b1f2e2724dfaf45519c49248b2c5dac8f18e9aed252  evidence/82-billing-all.txt
b708c7aa1ef24fe86f81c80fd4fbbe1f3b7b65c64add4e7923c48a3dbfc284a1  evidence/82-billing-all-status-after.txt
9585496cc929778e939af590008baa0df8f2541622d780bf501a64332c11d42d  evidence/82-billing-all-status-before.txt
faf56289389eb4c2300ccadcf3ae7917981f2449185f672266e18689f3c4c671  evidence/82-ctx.txt
13e2711a1f2d8b2a394024029f8a7b318aa31200e7ca9270564bcba6da5fa232  evidence/82-detecting-start.txt
98b239b8b7c3ca4f37bfa0b65c12ca6bf1412a5e027593dea5174016a3994f81  evidence/82-detect-ow1.txt
8d7ad7558b7802f08a70de70033618eb753e533cdc075505cd0ac8397f8fe623  evidence/82-detect-ow1-status-after.txt
a6b2d19f7cba4f6cd332ceddbd96f30dc7664ef1b6fd1b3d93a05ba0df571611  evidence/82-detect-ow1-status-before.txt
3c2094d420245204a47e5d58fb069e419c34e03f7e0d004c2d4a7cfc094446c5  evidence/82-detect-ow2.txt
52e056e94ce4aac7b6af04351e239cdb0d86a6ffc0e5808d472f66a1f12c6f3a  evidence/82-detect-ow2-status-after.txt
6bba7ad2f7b0959fb4aeb7d67336f7ca24f8210ab43f10d27ea2851904609c63  evidence/82-detect-ow2-status-before.txt
77036010b34a6804ff797700aebdc55ca1608f0a7802e13896ba18b33a64d2e5  evidence/82-detect-ow3.txt
6b9609e659dc7e43501b99d50ba6b0c4c98a57f02f16e2cc5c2d903dec51b3ac  evidence/82-detect-ow3-status-after.txt
a2a5daf50eda80dead09b4ccaeb82fcee801d4b9168815d85ae50a590321ae24  evidence/82-detect-ow3-status-before.txt
32a97dd0ccc3a2174a9432c36edcdcb327952e67a74c1647e0d3e7006bfd2728  evidence/82-detect-ow4.txt
fb3b51db87f79aa573d0b37af67d5625c4bee66df80e8bc0654d2d3c5e03f2c9  evidence/82-detect-ow4-status-after.txt
ff03a0e7db29dae49c96309f997462703990c51da2e21f293d73ed6484846d5f  evidence/82-detect-ow4-status-before.txt
915b8ed59db28b34dbe9d0ee003c874541c1a6a1714b684176ee1b53d3f71e91  evidence/82-detect-ow5.txt
30d81c9eb7da4546add56e0d6d6c7520090567bc09ef4cd3633f08d352f6e9ff  evidence/82-detect-ow5-status-after.txt
491245868f52fe3b2916fc98e05e719fe0a7226fdc9b128a9d242be890fae722  evidence/82-detect-ow5-status-before.txt
6061f3b27b52d5180209e6dab8e4854b22f3edec873e4cffb124e427dd2bc385  evidence/82-drop-schema.txt
a495909f56dd2a7df03ed8c2a5b48439a70e53ca4015ba8c401f8d0537f74951  evidence/82-error-log.txt
72ee788ce4e43302a365984e7cb7c153649e0d608cff6fdbffbffa5320199687  evidence/82-fw-allowlist.txt
570c3f2639340093175e3a94ae1be5bc964daacc693b0622720c5c6770872b6c  evidence/82-fw-enlist.txt
1db40a66bfba67447e6318aba29069f9c066211bc5d8fa03691fd917697b93bd  evidence/82-fw-install.txt
35b0197f4432dcf27f9069e8edad82a45605134eccf043870f28ff2f4532766a  evidence/82-fw-protecting-start.txt
80cc4facb360456b4cd26b2c744e02d3ec04d6486fdb8c685cce58e421408593  evidence/82-fw-recording.txt
0522fcbb1ac31acd32d80e84ee4112a3d36fcfd3c9bab504b01c55e56b8a90be  evidence/82-fw-state.txt
c2c25c06c8ae5a06bcf8ec34fe93c9ba734bcc435a767f9e3ebae9c35ab973df  evidence/82-fw-uninstall.txt
503a2586b60c0def99e8e9224f2d97e08eda5bdc1f3457388d682aa3700a9c87  evidence/82-groups-teardown.txt
dd71e7a8dd26d9b94bcefb9a3767054ee3768b06f0887538f6d3b5326532a003  evidence/82-inject-literal.txt
7c181b8d1aa05a096d5876dae9d54dd9be4f8bdbb7147a4e9ea2085e3a0fb213  evidence/82-inject-literal-status-after.txt
c494e2c37142f970e9e06ed411b0965d87763e9eaaea9f21389766c069cf814b  evidence/82-inject-literal-status-before.txt
71db7ecb5c31f06f90f95f72b5d808dd3c16ef41506c556e545ba036f4fe6371  evidence/82-inject-or.txt
61e6c647de26770fb279d5d9b6c28d80da692f994454d5ceb88bd3aeb3ea8b46  evidence/82-inject-or-status-after.txt
b4be03feab0dd663d77c16da381d0b270484758018324a95885af1115157aad3  evidence/82-inject-or-status-before.txt
42a52fda10b507bd483e1cf02d45cfdc526fa40406f1ef4599cd989d8fc13726  evidence/82-norole-find-customer.txt
0db0782c150571cae48c20951a31411d6041b7ac312540d1be43f49b3c089df7  evidence/82-norole-find-customer-status-after.txt
720003803a3bf98c24ab580a07e5555f3a6892d9d069cc25ba2e7ff95c409b14  evidence/82-norole-find-customer-status-before.txt
72d93100504d0d66c52e218d74c18d10e40603e55a5237d3fbbb05092e166985  evidence/82-norole-group.txt
b114803b034f85a8bc55de803492d78090507dffea9e139e6fcb8a9fd5bf0457  evidence/82-norole-protecting.txt
4a5f17149cbe37dbe2fdffa8ccc2e134bfd1e798be314b95a89ab7e44b5412a6  evidence/82-norole-record.txt
c2214a697ef13e9e14d729184834e2e361d05fd2de3db7b3eb57f3b8c65d1ae1  evidence/82-norole-recorded-shape.txt
808e50555f1416639c35ce209a2c43057a493cc61a6d070431fd68e8e4d9a84f  evidence/82-norole-recorded-shape-status-after.txt
f89ae3049ac490a87065b54ff5743251838990f7dbb6f8b3bf3cf054de369b06  evidence/82-norole-recorded-shape-status-before.txt
3f9e7ff92cf4ec884a04d728bbe13db34f6bd025c010fa85b74e04098b847a55  evidence/82-recording-run.txt
c71f897ec522cf1a728e15b71e6de1d281c534cd4406e774b6bced7983be8143  evidence/82-reset-persist.txt
e07a2ba68f9e3c919d9d775385c45a0be8b84fc66c5eeb4a1825c014ea73982a  evidence/82-schema-create.txt
05e0685bf24944ba5afab971c90529d92610aad7943514cab756d6049836defc  evidence/82-shape-bilal.txt
a1ea4f191b3bf47d0134fd7a6b945b1101e5e7d1cc3ab9a4476e3dc4f1358fb8  evidence/82-shape-bilal-status-after.txt
0153005fc944b23d3912d045ef82c7e4c2322eb7e20850cb935faa674574c893  evidence/82-shape-bilal-status-before.txt
117f5a4817f6f827a3e2ef5ca74f7fbb166df0e8f45ce83ffeeec189534a2daa  evidence/82-shape-chen.txt
fe9828b5c1aac59a721a86a429e7dbe9d36527189d06dcab30bbb34ed501d9d4  evidence/82-shape-chen-status-after.txt
118ce3a57d4c26335c3de2fb21c6aaff91760c7d68af44e322cb391ee379b0ab  evidence/82-shape-chen-status-before.txt
81275e3d89dae2e3d8af515eb7a91ccf7befbc93377d8cdcb0e11ea5168577d5  evidence/82-shape-nobody.txt
028b6619524dec32fd6e02b87cc89598f98c097a23b2780a268580146f3f1011  evidence/82-shape-nobody-status-after.txt
9409bc767fc8a46fd90df7657218e7277cf693c488f29d48c8c3455c611d13ed  evidence/82-shape-nobody-status-before.txt
6e82c7fad5db4c4c022985d5f62da2977f90f4eec7607032c7e382f4a17cada1  evidence/82-teardown-precheck.txt
e0bde58312f8fdf4942fc4e529fe9d0ff7a489eaa57c0d8d57db319108b76c86  evidence/83-audit-extract.txt
47c9be8142ed7b42f5724966f539bbfc1b1a495f4d01bab9907804f0f7c3be44  evidence/83-audit-install.txt
3529362b1e98e850449f3c2bac3e29297ba7d173f07cdcf31997f50841462deb  evidence/83-audit-remove.txt
e1bfa79dead741ffdf55ea7070b446b54c94f8e8941e11a73317a3e38322ab05  evidence/83-audit-uninstall.txt
9555639073f8626bd9aa8107902156f5d85f04ec89fe718ec73d29be3f873ef0  evidence/83-filters.txt
a2d8cd86a9594063dd6e4d1888361ed94e4ad3c680e0548264d547adb7e5e8af  evidence/83-pw-statements.txt
585994c7e5129c0546e93c422f173acee3d39ad0c82b976594086e80ee61f52e  evidence/83-root-filter.txt
a10b64732731d6a573b0726160826118ed8b3259aef05238610108d2dd896317  evidence/83-root-unassign.txt
afe2e457116022d9b4ebb25d50db5895316645f1d980e82a91a6a6a9446d6740  evidence/83-select-agent.txt
42036841693c9a6dfbbaf85bbdc360e2b47ad0bfacc5ed416d84e8806d442370  evidence/83-select-billing.txt
a939d9b31581c2bf3ea40c565ae24e70db32eec290d01d3044324e30cac47d39  evidence/83-select-norole.txt
00ad030c8948c22e70eb38e1a1311d4071240777a66e20dc2e28e6fe69933256  evidence/83-status-agent.txt
2329f8cd8214a015d5de561ce565a217911080c340cec6b2151957d5fc75db05  evidence/83-status-billing.txt
1b54c7f1219c8b84089e7c602561cfcf9ff3a6cd365c28ceeb00a16917e47d6e  evidence/83-status-norole.txt
c2cfc0d1a8cc464b2b0a3d1bd518210d6e3075dfa079557384ffedf5f5d1739e  evidence/83-status-root.txt
c791417a6c024ee92a42c328df12331363fb776ba4411b110e08f2a510504d11  evidence/84-after.txt
25871ed4af64026f2f5fe4ef833c74c8069c3a39d805ac996539211b9cb0dc64  evidence/84-cleanup.txt
d099cfc6153c6e41b70db75d01c2d8b6134019bb7bb4aa5451337d6b1627631a  evidence/84-compare.txt
31b6a992a61c99d3012602351508bfe67c79a2a3186b859a7dec433750dc785c  sql/80-a1-stmt.sql
c94cc4a48b5c035fd4e3ad8f412d924da0fc56a5b01f990151738fd799fb6dae  sql/80-a2-root-reattach.sql
c7b890dc61c06d503e4665f8080c2f5e924776bca7f855f3ee41177aa0f2272d  sql/80-a3-stmt.sql
30e2ab2c05c7c9d2c802052865e6cc842ebab348a71fb47f229dbb3b77fa44f0  sql/80-a4a-stmt.sql
dacc45d44cf270a185b3eeb453dd13bd578aaf8dcecccea2744b7dfdb98fca3a  sql/80-a4b-stmt.sql
607e457d491c1ff02f0736f9ca3a1f985e0b6c5b90bd83f873db1e9377020f6b  sql/80-a4c-stmt.sql
31e701414e85e8c9bdb45fad0969ded45e0a968c3635b58d021d3c084d249f68  sql/80-a4-root-restore.sql
d663f1798038ca814c3f30aec62e99d0f158bb8509731b421b9ff25202e8366a  sql/80-a5-root-restore.sql
6902c71a7571ea3a2f09dc440e330eb939c087c16fa5d5add856ad969b3afc84  sql/80-a5-stmt.sql
1ca4864f0b0087bbf3cb30fb57c9e9b8de4d11a1690de7b404b71797bd3408db  sql/80-a-after.sql
cbdd7d5bee95b6a5e018471cdf91809f6517a45b50ed306464b8cd4f70629d13  sql/80-a-setup.sql
3d2eb328054a837299d04a348fabebb47795ac93c786fabd0f04ab1d1382c667  sql/81-01.sql
fc65de1cb5ab49ae416a13beded4965bfbb4881bf44663b176de62c42a39667b  sql/81-02.sql
11da32ecfbaf64b9b4c3ea025f3a0c4ed008f65c5b2105632943693abc365f51  sql/81-03.sql
3e283ee736d7385c0f338f8ec6ee5fea8bcb5b65be039a049977508985c48f51  sql/81-04.sql
e958a90ac8b3f0e68e48ed389df851d0e7ec4db76987fdcc383b9352c7bdc0f9  sql/81-05.sql
09cf3d3668f1e0bb2ab5714c4822ae263261ec7d88d9d4fb36e13cb452b18932  sql/81-06.sql
fb6ff375a372c527f42258b3c8088a4e17fc83c63e9e09d7adf3e989e6168b74  sql/81-07.sql
bcc35250a60223cbb22b3a3d0c465445b7f6fa457a4ed3449ea4332fd8a32435  sql/81-08.sql
8b4467bae7c6cfee21ad3dd248ce3ffee6dda450498518ddda2d745b55c4bde0  sql/81-09.sql
f81c45856ed215e196ef16ec5a7bc5e4d5d7bc179de643d795281141ed5d515b  sql/81-10.sql
953b62506fe60a9268b046e34aff09426cabd4a48d52c8e5297e33cae21968ad  sql/81-11.sql
76e353f2eb6930d0660614ce412f8a346a09b910727ddd8a9c16a2eb64e929d5  sql/81-12.sql
8e03724cda5de67a026eaf17206fc4e3d73a758ca9f82cdb2b78369464bfea0b  sql/81-setup.sql
07a020ad02a6c4beaefd30cce44dec18335d4ce2509bd142cb38cbb1a57644b9  sql/82-billing-all.sql
ba0696264706e3dfb259109a26e12c5d5b31a7c46ef1d6a810f7e62f0050f85e  sql/82-detecting-start.sql
6be11f7af0dceb812aab9c7b7345182d9f0c1046df4b933f22b3d3b413a15786  sql/82-error-log.sql
c21a4f31829bff85fc1e361be10c2c1f4e43d2382771a6cd3275aa4c91fcee81  sql/82-groups-teardown.sql
da7225af18697402267197cc73fcd8901d0ae725b5c6c470ea92a78e4149a983  sql/82-inject-literal.sql
73f65587551ba40206c7d9423ac8276df6a26a565802f23b86386a3e3bd2e8ed  sql/82-inject-or.sql
2b4e4726fdbc82205c4441f76162f6b3cfe7a11014bde93f487540d2e7e2f302  sql/82-norole-count.sql
eb807fe6b24a6b338c15055cfe5a8504540a263c97d59fd285d806d60481b1e2  sql/82-norole-group.sql
633ede6ee5d83d4be39a20df381a5182417b2ac47680b0430ef246f2b01403c9  sql/82-norole-protecting.sql
5ac32a6107230af3c78739fb2daf2449601cec6fa3ac82417ad6c994935011de  sql/82-norole-shape.sql
5ac32a6107230af3c78739fb2daf2449601cec6fa3ac82417ad6c994935011de  sql/82-shape-bilal.sql
74962a9276c7fd66455738e058c6a51827d024cdbb7af2f610e4de4e950409b4  sql/82-shape-chen.sql
de60e8081d2b44552ec3b03bb350a33a267077a08b15eb2bfc5e2ddf214dd3e1  sql/82-shape-nobody.sql
c496472eee975f2e69419d0186740868d7d548eeabe7bf5c4cac9e410e5dbe32  sql/83-audit-remove.sql
5518c53bea01d7e86ecea368af5a00a2f9a91f7bd0045cb9f50a0fc1b0429ae8  sql/83-filters.sql
86fde266d765d4816187b8e16265643203d647e642fb4d65a7da6253a04b5c16  sql/83-pw-statements.sql
972775335c28d877fe4ded6e50bf6e3fa342582df1855d06c998e8f9b14d7f07  sql/83-root-filter.sql
1686b8603979cf6fb67f05aa7f605b432fdbedfc78301a9be5573264b86ddb31  sql/83-root-unassign.sql
acad1ab9021719e43f65e075b2e0d06617691d3692b30b210cffcf6d29a6a036  sql/84-cleanup.sql
```

## Evidence (verbatim)

### evidence/80-a1-after.txt
````text
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                  |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.008 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | 555-0101 | note one   |
|  2 | 777-0101 | note two   |
|  3 | 555-0303 | note three |
+----+----------+------------+
3 rows in set (0.005 sec)

Bye
````

### evidence/80-a1-stmt.txt
````text
--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20)
--------------

Query OK, 0 rows affected (0.073 sec)
Records: 0  Duplicates: 0  Warnings: 0

Bye
````

### evidence/80-a2-root-reattach.txt
````text
--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone
--------------

Query OK, 0 rows affected (0.315 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.010 sec)

Bye
````

### evidence/80-a3-after.txt
````text
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.010 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/80-a3-stmt.txt
````text
--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone
--------------

Query OK, 0 rows affected (0.204 sec)
Records: 0  Duplicates: 0  Warnings: 0

Bye
````

### evidence/80-a4-after.txt
````text
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                                                              |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  `phone_copy` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.008 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+------------+
| id | phone    | notes      | phone_copy |
+----+----------+------------+------------+
|  1 | ****0101 | note one   | ****0101   |
|  2 | ****0101 | note two   | ****0101   |
|  3 | ****0303 | note three | ****0303   |
+----+----------+------------+------------+
3 rows in set (0.003 sec)

Bye
````

### evidence/80-a4a-stmt.txt
````text
--------------
ALTER TABLE probe_alter ADD COLUMN phone_copy VARCHAR(20)
--------------

Query OK, 0 rows affected (0.208 sec)
Records: 0  Duplicates: 0  Warnings: 0

Bye
````

### evidence/80-a4b-stmt.txt
````text
--------------
UPDATE probe_alter SET phone_copy = phone
--------------

Query OK, 3 rows affected (0.045 sec)
Rows matched: 3  Changed: 3  Warnings: 0

Bye
````

### evidence/80-a4c-stmt.txt
````text
--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+------------+
| id | phone    | notes      | phone_copy |
+----+----------+------------+------------+
|  1 | ****0101 | note one   | ****0101   |
|  2 | ****0101 | note two   | ****0101   |
|  3 | ****0303 | note three | ****0303   |
+----+----------+------------+------------+
3 rows in set (0.006 sec)

Bye
````

### evidence/80-a4-root-restore.txt
````text
--------------
ALTER TABLE probe_alter DROP COLUMN phone_copy
--------------

Query OK, 0 rows affected (0.272 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.009 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.010 sec)

Bye
````

### evidence/80-a5-after.txt
````text
--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                   |
+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.032 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone2   | notes      |
+----+----------+------------+
|  1 | 555-0101 | note one   |
|  2 | 777-0101 | note two   |
|  3 | 555-0303 | note three |
+----+----------+------------+
3 rows in set (0.008 sec)

Bye
````

### evidence/80-a5-root-restore.txt
````text
--------------
ALTER TABLE probe_alter CHANGE COLUMN phone2 phone VARCHAR(20) MASKING POLICY probe4_mask_phone
--------------

Query OK, 0 rows affected (0.406 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.011 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.012 sec)

Bye
````

### evidence/80-a5-stmt.txt
````text
--------------
ALTER TABLE probe_alter CHANGE COLUMN phone phone2 VARCHAR(20)
--------------

Query OK, 0 rows affected (0.308 sec)
Records: 0  Duplicates: 0  Warnings: 0

Bye
````

### evidence/80-a-setup-root.txt
````text
--------------
CREATE SCHEMA ddv_probe4
--------------

Query OK, 1 row affected (0.113 sec)

--------------
USE ddv_probe4
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
CREATE TABLE probe_alter (
  id INT PRIMARY KEY,
  phone VARCHAR(20),
  notes TEXT
)
--------------

Query OK, 0 rows affected (0.273 sec)

--------------
INSERT INTO probe_alter VALUES
  (1, '555-0101', 'note one'),
  (2, '777-0101', 'note two'),
  (3, '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.055 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
CREATE MASKING POLICY probe4_mask_phone(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.051 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
ALTER TABLE probe_alter MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone
--------------

Query OK, 0 rows affected (0.105 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.001 sec)

--------------
GRANT SELECT, ALTER, INSERT, UPDATE ON ddv_probe4.probe_alter TO 'ddv_alterer'@'%'
--------------

Query OK, 0 rows affected (0.034 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
SHOW GRANTS FOR 'ddv_alterer'@'%'
--------------

+----------------------------------------------------------------------------------------+
| Grants for ddv_alterer@%                                                               |
+----------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_alterer`@`%`                                                |
| GRANT SELECT, INSERT, UPDATE, ALTER ON `ddv_probe4`.`probe_alter` TO `ddv_alterer`@`%` |
+----------------------------------------------------------------------------------------+
2 rows in set (0.009 sec)

--------------
SHOW CREATE TABLE probe_alter
--------------

+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                                                                                                                     |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_alter | CREATE TABLE `probe_alter` (
  `id` int NOT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.039 sec)

--------------
SELECT * FROM probe_alter
--------------

+----+----------+------------+
| id | phone    | notes      |
+----+----------+------------+
|  1 | ****0101 | note one   |
|  2 | ****0101 | note two   |
|  3 | ****0303 | note three |
+----+----------+------------+
3 rows in set (0.005 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe4%'
--------------

+-------------------+
| policy_name       |
+-------------------+
| probe4_mask_phone |
+-------------------+
1 row in set (0.005 sec)

Bye
````

### evidence/80-baseline.txt
````text
--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
+--------------+--------------------+------------------------------------+
3 rows in set (0.040 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.105 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.100 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.013 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
|   7 | event_scheduler | localhost       | Daemon  |
| 231 | root            | localhost:53514 | Query   |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.024 sec)

Bye
````

### evidence/81-agent-01.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.033 sec)

--------------
SELECT COUNT(*), COUNT(DISTINCT email), COUNT(DISTINCT phone) FROM probe_people
--------------

+----------+-----------------------+-----------------------+
| COUNT(*) | COUNT(DISTINCT email) | COUNT(DISTINCT phone) |
+----------+-----------------------+-----------------------+
|        3 |                     2 |                     2 |
+----------+-----------------------+-----------------------+
1 row in set (0.043 sec)

Bye
````

### evidence/81-agent-02.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.008 sec)

--------------
SELECT phone, GROUP_CONCAT(id ORDER BY id) FROM probe_people GROUP BY phone
--------------

+----------+------------------------------+
| phone    | GROUP_CONCAT(id ORDER BY id) |
+----------+------------------------------+
| ****0101 | 1,2                          |
| ****0303 | 3                            |
+----------+------------------------------+
2 rows in set, 1 warning (0.173 sec)

Warning (Code 1052): Column 'phone' in group statement is ambiguous
Bye
````

### evidence/81-agent-03.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.009 sec)

--------------
SELECT id FROM probe_people WHERE phone IN (SELECT phone FROM probe_people WHERE id = 1) ORDER BY id
--------------

+----+
| id |
+----+
|  1 |
|  2 |
+----+
2 rows in set (0.034 sec)

Bye
````

### evidence/81-agent-04.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.008 sec)

--------------
SELECT id, SUBSTRING(email,1,6), SUBSTRING_INDEX(email,'@',1) FROM probe_people ORDER BY id
--------------

+----+----------------------+------------------------------+
| id | SUBSTRING(email,1,6) | SUBSTRING_INDEX(email,'@',1) |
+----+----------------------+------------------------------+
|  1 | m*****               | m********                    |
|  2 | m*****               | m********                    |
|  3 | l*****               | l********                    |
+----+----------------------+------------------------------+
3 rows in set (0.025 sec)

Bye
````

### evidence/81-agent-05.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.009 sec)

--------------
SELECT MIN(phone), MAX(phone) FROM probe_people
--------------

+------------+------------+
| MIN(phone) | MAX(phone) |
+------------+------------+
| ****0101   | ****0303   |
+------------+------------+
1 row in set (0.016 sec)

Bye
````

### evidence/81-agent-06.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.006 sec)

--------------
SELECT email FROM probe_people UNION SELECT phone FROM probe_people
--------------

+------------------------+
| email                  |
+------------------------+
| m********@example.test |
| l********@example.test |
| ****0101               |
| ****0303               |
+------------------------+
4 rows in set (0.021 sec)

Bye
````

### evidence/81-agent-07.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.009 sec)

--------------
WITH c AS (SELECT id, email FROM probe_people) SELECT id, email FROM c ORDER BY email
--------------

+----+------------------------+
| id | email                  |
+----+------------------------+
|  3 | l********@example.test |
|  1 | m********@example.test |
|  2 | m********@example.test |
+----+------------------------+
3 rows in set (0.137 sec)

Bye
````

### evidence/81-agent-08.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.005 sec)

--------------
SELECT id, ROW_NUMBER() OVER (ORDER BY email) rn FROM probe_people ORDER BY id
--------------

+----+----+
| id | rn |
+----+----+
|  1 |  2 |
|  2 |  3 |
|  3 |  1 |
+----+----+
3 rows in set (0.068 sec)

Bye
````

### evidence/81-agent-09.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.008 sec)

--------------
SELECT id FROM probe_people WHERE email REGEXP '^mark\\.z'
--------------

Empty set (0.162 sec)

Bye
````

### evidence/81-agent-10.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.008 sec)

--------------
SELECT id FROM probe_people WHERE email BETWEEN 'm' AND 'n' ORDER BY id
--------------

+----+
| id |
+----+
|  1 |
|  2 |
+----+
2 rows in set (0.042 sec)

Bye
````

### evidence/81-agent-11.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.009 sec)

--------------
SELECT id, HEX(email) FROM probe_people ORDER BY id
--------------

+----+----------------------------------------------+
| id | HEX(email)                                   |
+----+----------------------------------------------+
|  1 | 6D2A2A2A2A2A2A2A2A406578616D706C652E74657374 |
|  2 | 6D2A2A2A2A2A2A2A2A406578616D706C652E74657374 |
|  3 | 6C2A2A2A2A2A2A2A2A406578616D706C652E74657374 |
+----+----------------------------------------------+
3 rows in set (0.152 sec)

Bye
````

### evidence/81-agent-12.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_agent@%    | `r_support_agent`@`%` |
+----------------+-----------------------+
1 row in set (0.010 sec)

--------------
SELECT id FROM probe_people WHERE email = 'mark.zzzz@example.test'
--------------

Empty set (0.020 sec)

Bye
````

### evidence/81-billing-01.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.010 sec)

--------------
SELECT COUNT(*), COUNT(DISTINCT email), COUNT(DISTINCT phone) FROM probe_people
--------------

+----------+-----------------------+-----------------------+
| COUNT(*) | COUNT(DISTINCT email) | COUNT(DISTINCT phone) |
+----------+-----------------------+-----------------------+
|        3 |                     3 |                     3 |
+----------+-----------------------+-----------------------+
1 row in set (0.032 sec)

Bye
````

### evidence/81-billing-02.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.012 sec)

--------------
SELECT phone, GROUP_CONCAT(id ORDER BY id) FROM probe_people GROUP BY phone
--------------

+----------+------------------------------+
| phone    | GROUP_CONCAT(id ORDER BY id) |
+----------+------------------------------+
| 555-0101 | 1                            |
| 555-0303 | 3                            |
| 777-0101 | 2                            |
+----------+------------------------------+
3 rows in set, 1 warning (0.023 sec)

Warning (Code 1052): Column 'phone' in group statement is ambiguous
Bye
````

### evidence/81-billing-03.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.009 sec)

--------------
SELECT id FROM probe_people WHERE phone IN (SELECT phone FROM probe_people WHERE id = 1) ORDER BY id
--------------

+----+
| id |
+----+
|  1 |
+----+
1 row in set (0.024 sec)

Bye
````

### evidence/81-billing-04.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.011 sec)

--------------
SELECT id, SUBSTRING(email,1,6), SUBSTRING_INDEX(email,'@',1) FROM probe_people ORDER BY id
--------------

+----+----------------------+------------------------------+
| id | SUBSTRING(email,1,6) | SUBSTRING_INDEX(email,'@',1) |
+----+----------------------+------------------------------+
|  1 | mark.z               | mark.zzzz                    |
|  2 | mark.a               | mark.aaaa                    |
|  3 | lena.m               | lena.mmmm                    |
+----+----------------------+------------------------------+
3 rows in set (0.019 sec)

Bye
````

### evidence/81-billing-05.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.012 sec)

--------------
SELECT MIN(phone), MAX(phone) FROM probe_people
--------------

+------------+------------+
| MIN(phone) | MAX(phone) |
+------------+------------+
| 555-0101   | 777-0101   |
+------------+------------+
1 row in set (0.012 sec)

Bye
````

### evidence/81-billing-06.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.013 sec)

--------------
SELECT email FROM probe_people UNION SELECT phone FROM probe_people
--------------

+------------------------+
| email                  |
+------------------------+
| mark.zzzz@example.test |
| mark.aaaa@example.test |
| lena.mmmm@example.test |
| 555-0101               |
| 777-0101               |
| 555-0303               |
+------------------------+
6 rows in set (0.027 sec)

Bye
````

### evidence/81-billing-07.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.007 sec)

--------------
WITH c AS (SELECT id, email FROM probe_people) SELECT id, email FROM c ORDER BY email
--------------

+----+------------------------+
| id | email                  |
+----+------------------------+
|  3 | lena.mmmm@example.test |
|  2 | mark.aaaa@example.test |
|  1 | mark.zzzz@example.test |
+----+------------------------+
3 rows in set (0.016 sec)

Bye
````

### evidence/81-billing-08.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.008 sec)

--------------
SELECT id, ROW_NUMBER() OVER (ORDER BY email) rn FROM probe_people ORDER BY id
--------------

+----+----+
| id | rn |
+----+----+
|  1 |  3 |
|  2 |  2 |
|  3 |  1 |
+----+----+
3 rows in set (0.015 sec)

Bye
````

### evidence/81-billing-09.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.010 sec)

--------------
SELECT id FROM probe_people WHERE email REGEXP '^mark\\.z'
--------------

+----+
| id |
+----+
|  1 |
+----+
1 row in set (0.146 sec)

Bye
````

### evidence/81-billing-10.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.010 sec)

--------------
SELECT id FROM probe_people WHERE email BETWEEN 'm' AND 'n' ORDER BY id
--------------

+----+
| id |
+----+
|  1 |
|  2 |
+----+
2 rows in set (0.013 sec)

Bye
````

### evidence/81-billing-11.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.010 sec)

--------------
SELECT id, HEX(email) FROM probe_people ORDER BY id
--------------

+----+----------------------------------------------+
| id | HEX(email)                                   |
+----+----------------------------------------------+
|  1 | 6D61726B2E7A7A7A7A406578616D706C652E74657374 |
|  2 | 6D61726B2E61616161406578616D706C652E74657374 |
|  3 | 6C656E612E6D6D6D6D406578616D706C652E74657374 |
+----+----------------------------------------------+
3 rows in set (0.013 sec)

Bye
````

### evidence/81-billing-12.txt
````text
--------------
SELECT CURRENT_USER(), CURRENT_ROLE()
--------------

+----------------+-----------------------+
| CURRENT_USER() | CURRENT_ROLE()        |
+----------------+-----------------------+
| ddv_billing@%  | `r_billing_admin`@`%` |
+----------------+-----------------------+
1 row in set (0.013 sec)

--------------
SELECT id FROM probe_people WHERE email = 'mark.zzzz@example.test'
--------------

+----+
| id |
+----+
|  1 |
+----+
1 row in set (0.014 sec)

Bye
````

### evidence/81-setup-root.txt
````text
--------------
USE ddv_probe4
--------------

Query OK, 0 rows affected (0.010 sec)

--------------
CREATE TABLE probe_people (
  id INT PRIMARY KEY,
  email VARCHAR(100),
  phone VARCHAR(20),
  notes TEXT
)
--------------

Query OK, 0 rows affected (0.490 sec)

--------------
INSERT INTO probe_people VALUES
  (1, 'mark.zzzz@example.test', '555-0101', 'note one'),
  (2, 'mark.aaaa@example.test', '777-0101', 'note two'),
  (3, 'lena.mmmm@example.test', '555-0303', 'note three')
--------------

Query OK, 3 rows affected (0.065 sec)
Records: 3  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
CREATE MASKING POLICY probe4_mask_email(email_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN email_column
     ELSE mask_inner(email_column, 1, 13, '*')
END
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
CREATE MASKING POLICY probe4_mask_phone2(phone_column)
CASE WHEN CURRENT_ROLE_IN('r_billing_admin')
     THEN phone_column
     ELSE mask_inner(phone_column, 0, 4, '*')
END
--------------

Query OK, 0 rows affected (0.046 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
ALTER TABLE probe_people MODIFY COLUMN email VARCHAR(100) MASKING POLICY probe4_mask_email
--------------

Query OK, 0 rows affected (0.104 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
ALTER TABLE probe_people MODIFY COLUMN phone VARCHAR(20) MASKING POLICY probe4_mask_phone2
--------------

Query OK, 0 rows affected (0.119 sec)
Records: 0  Duplicates: 0  Warnings: 0

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
GRANT SELECT ON ddv_probe4.probe_people TO 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.050 sec)

--------------
GRANT SELECT ON ddv_probe4.probe_people TO 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.004 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+--------------------------------------------------------------------+
| Grants for ddv_agent@%                                             |
+--------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                              |
| GRANT SELECT ON `ddv_probe4`.`probe_people` TO `ddv_agent`@`%`     |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                     |
+--------------------------------------------------------------------+
7 rows in set (0.005 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_billing@%                                             |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                              |
| GRANT SELECT ON `ddv_probe4`.`probe_people` TO `ddv_billing`@`%`     |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                     |
+----------------------------------------------------------------------+
7 rows in set (0.010 sec)

--------------
SHOW CREATE TABLE probe_people
--------------

+--------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table        | Create Table                                                                                                                                                                                                                                                                                               |
+--------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| probe_people | CREATE TABLE `probe_people` (
  `id` int NOT NULL,
  `email` varchar(100) MASKING POLICY `probe4_mask_email` DEFAULT NULL,
  `phone` varchar(20) MASKING POLICY `probe4_mask_phone2` DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.011 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe4%'
--------------

+--------------------+
| policy_name        |
+--------------------+
| probe4_mask_email  |
| probe4_mask_phone  |
| probe4_mask_phone2 |
+--------------------+
3 rows in set (0.014 sec)

Bye
````

### evidence/82-agent-count-orders.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

ERROR 6444 (28000) at line 1: Access denied.
ERROR 6444 (28000) at line 1: Access denied.
ERROR 6444 (28000) at line 1: Access denied.
Bye
````

### evidence/82-agent-count-orders-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 23    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.025 sec)

Bye
````

### evidence/82-agent-count-orders-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 9     |
| firewall_access_granted    | 23    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.016 sec)

Bye
````

### evidence/82-billing-all.txt
````text
--------------
SELECT * FROM ddv_support.customers
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | 555-0101 | asha.example@example.test     | TEST-0001 |
|  2 | Bilal Sample     | 555-0102 | bilal.sample@example.test     | TEST-0002 |
|  3 | Chen Demo        | 555-0103 | chen.demo@example.test        | TEST-0003 |
|  4 | Dana Placeholder | 555-0104 | dana.placeholder@example.test | TEST-0004 |
|  5 | Elif Fictional   | 555-0105 | elif.fictional@example.test   | TEST-0005 |
|  6 | Farid Mock       | 555-0106 | farid.mock@example.test       | TEST-0006 |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.016 sec)

Bye
````

### evidence/82-billing-all-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 18    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/82-billing-all-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 18    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.021 sec)

Bye
````

### evidence/82-ctx.txt
````text
HEADER: NO LLM IS CALLED. This is the text a model WOULD receive as
context for each question. Produced by agent/support_agent.py as ddv_agent.

##### CONTEXT FOR QUESTION 1 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Where is order 102?
TOOL RESULTS:
- find_customer('Asha Example') -> 1 row(s)
    id=1, full_name=Asha Example, phone=****0101, email=a***********@example.test, tax_id=*********
- list_orders(1) -> 2 row(s)
    id=101, status=delivered, total_amount=1250.00, created_at=2026-09-01 10:15:00
    id=102, status=shipped, total_amount=349.50, created_at=2026-09-20 14:02:00
- payment_status(102) -> 1 row(s)
    id=1002, order_id=102, method=upi, card_number=None, upi_id=a************, status=captured, order_status=shipped

##### CONTEXT FOR QUESTION 2 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Verify caller Asha Example with last four 0101
TOOL RESULTS:
- find_customer('Asha Example') -> 1 row(s)
    id=1, full_name=Asha Example, phone=****0101, email=a***********@example.test, tax_id=*********
- verify_last4(1, '0101') -> 1 row(s)
    matches=1

##### CONTEXT FOR QUESTION 3 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: Why did Chen Demo's charge fail?
TOOL RESULTS:
- find_customer('Chen Demo') -> 1 row(s)
    id=3, full_name=Chen Demo, phone=****0103, email=c********@example.test, tax_id=*********
- list_orders(3) -> 2 row(s)
    id=105, status=pending, total_amount=45.00, created_at=2026-10-02 11:05:00
    id=106, status=delivered, total_amount=310.75, created_at=2026-09-28 18:30:00
- payment_status(105) -> 1 row(s)
    id=1005, order_id=105, method=upi, card_number=None, upi_id=c************, status=pending, order_status=pending
- payment_status(106) -> 1 row(s)
    id=1006, order_id=106, method=card, card_number=***********0005, upi_id=None, status=captured, order_status=delivered
- ticket_notes(3) -> 1 row(s)
    id=3, subject=Charge failed, please call back, notes=Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge.

##### CONTEXT FOR QUESTION 4 #####
SYSTEM: You are a support agent. Answer using only the tool results.
USER QUESTION: What is the refund status of order 104?
TOOL RESULTS:
- payment_status(104) -> 1 row(s)
    id=1004, order_id=104, method=card, card_number=************4444, upi_id=None, status=refunded, order_status=refunded
````

### evidence/82-detecting-start.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'DETECTING')
--------------

Query OK, 0 rows affected (0.214 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+-----------+------------+--------------+
| NAME      | MODE       | USERHOST     |
+-----------+------------+--------------+
| fw_agent  | DETECTING  | ddv_agent@%  |
| fw_norole | PROTECTING | ddv_norole@% |
+-----------+------------+--------------+
2 rows in set (0.002 sec)

Bye
````

### evidence/82-detect-ow1.txt
````text
--------------
SELECT * FROM ddv_support.customers
--------------

+----+------------------+----------+-------------------------------+-----------+
| id | full_name        | phone    | email                         | tax_id    |
+----+------------------+----------+-------------------------------+-----------+
|  1 | Asha Example     | ****0101 | a***********@example.test     | ********* |
|  2 | Bilal Sample     | ****0102 | b***********@example.test     | ********* |
|  3 | Chen Demo        | ****0103 | c********@example.test        | ********* |
|  4 | Dana Placeholder | ****0104 | d***************@example.test | ********* |
|  5 | Elif Fictional   | ****0105 | e*************@example.test   | ********* |
|  6 | Farid Mock       | ****0106 | f*********@example.test       | ********* |
+----+------------------+----------+-------------------------------+-----------+
6 rows in set (0.015 sec)

Bye
````

### evidence/82-detect-ow1-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 25    |
| firewall_access_suspicious | 2     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.010 sec)

Bye
````

### evidence/82-detect-ow1-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 23    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.025 sec)

Bye
````

### evidence/82-detect-ow2.txt
````text
--------------
SELECT * FROM ddv_support.payments
--------------

+------+----------+--------+------------------+----------------+----------+
| id   | order_id | method | card_number      | upi_id         | status   |
+------+----------+--------+------------------+----------------+----------+
| 1001 |      101 | card   | ************1111 | NULL           | captured |
| 1002 |      102 | upi    | NULL             | a************  | captured |
| 1003 |      103 | card   | ************4444 | NULL           | captured |
| 1004 |      104 | card   | ************4444 | NULL           | refunded |
| 1005 |      105 | upi    | NULL             | c************  | pending  |
| 1006 |      106 | card   | ***********0005  | NULL           | captured |
| 1007 |      107 | card   | ************1117 | NULL           | voided   |
| 1008 |      108 | upi    | NULL             | e************  | captured |
| 1009 |      109 | card   | ************4242 | NULL           | captured |
| 1010 |      110 | upi    | NULL             | f************* | pending  |
+------+----------+--------+------------------+----------------+----------+
10 rows in set (0.025 sec)

Bye
````

### evidence/82-detect-ow2-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 27    |
| firewall_access_suspicious | 4     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.010 sec)

Bye
````

### evidence/82-detect-ow2-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 25    |
| firewall_access_suspicious | 2     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.008 sec)

Bye
````

### evidence/82-detect-ow3.txt
````text
--------------
SELECT full_name FROM ddv_support.customers WHERE email LIKE 'a%'
--------------

+--------------+
| full_name    |
+--------------+
| Asha Example |
+--------------+
1 row in set (0.006 sec)

Bye
````

### evidence/82-detect-ow3-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 29    |
| firewall_access_suspicious | 6     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.050 sec)

Bye
````

### evidence/82-detect-ow3-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 27    |
| firewall_access_suspicious | 4     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/82-detect-ow4.txt
````text
--------------
SELECT * FROM ddv_support.support_tickets
--------------

+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
| id | customer_id | subject                         | notes                                                                                                               |
+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
|  1 |           1 | Where is my order 102?          | Customer asked for tracking. Shipped 2026-09-20.                                                                    |
|  2 |           2 | Refund for order 104            | Refund issued to original payment method.                                                                           |
|  3 |           3 | Charge failed, please call back | Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge. |
|  4 |           5 | Change delivery address         | Address change requested before shipment.                                                                           |
|  5 |           6 | Order 110 still pending         | Customer asked why payment is pending; UPI collect request sent.                                                    |
+----+-------------+---------------------------------+---------------------------------------------------------------------------------------------------------------------+
5 rows in set (0.013 sec)

Bye
````

### evidence/82-detect-ow4-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 31    |
| firewall_access_suspicious | 8     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.025 sec)

Bye
````

### evidence/82-detect-ow4-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 29    |
| firewall_access_suspicious | 6     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/82-detect-ow5.txt
````text
--------------
SELECT 1
--------------

+---+
| 1 |
+---+
| 1 |
+---+
1 row in set (0.005 sec)

Bye
````

### evidence/82-detect-ow5-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 33    |
| firewall_access_suspicious | 10    |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/82-detect-ow5-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 12    |
| firewall_access_granted    | 31    |
| firewall_access_suspicious | 8     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.021 sec)

Bye
````

### evidence/82-drop-schema.txt
````text
--------------
DROP SCHEMA ddv_sec
--------------

Query OK, 0 rows affected (0.375 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

Bye
````

### evidence/82-error-log.txt
````text
--------------
SELECT LOGGED, PRIO, SUBSYSTEM, DATA FROM performance_schema.error_log WHERE DATA LIKE '%irewall%' ORDER BY LOGGED DESC LIMIT 40
--------------

Empty set (0.012 sec)

--------------
SHOW VARIABLES LIKE 'log_error_verbosity'
--------------

+---------------------+-------+
| Variable_name       | Value |
+---------------------+-------+
| log_error_verbosity | 2     |
+---------------------+-------+
1 row in set (0.052 sec)

--------------
SHOW VARIABLES LIKE 'component_firewall.trace'
--------------

+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| component_firewall.trace | OFF   |
+--------------------------+-------+
1 row in set (0.044 sec)

Bye
````

### evidence/82-fw-allowlist.txt
````text
--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME     | RULE                                                                                                                                                                                                                                                                               |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set (0.014 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
1 row in set (0.010 sec)

--------------
SHOW STATUS LIKE '%firewall%'
--------------

+----------------------------------------------------+-------+
| Variable_name                                      | Value |
+----------------------------------------------------+-------+
| firewall_access_denied                             | 0     |
| firewall_access_granted                            | 14    |
| firewall_access_suspicious                         | 0     |
| firewall_cached_entries                            | 8     |
| option_tracker_usage:Enterprise Firewall component | 12    |
+----------------------------------------------------+-------+
5 rows in set (0.039 sec)

Bye
````

### evidence/82-fw-enlist.txt
````text
--------------
CALL ddv_sec.sp_firewall_group_enlist('fw_agent', 'ddv_agent@%')
--------------

Query OK, 0 rows affected (0.063 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+----------+-------------+
| GROUP_ID | MEMBER_ID   |
+----------+-------------+
| fw_agent | ddv_agent@% |
+----------+-------------+
1 row in set (0.003 sec)

Bye
````

### evidence/82-fw-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# This script installs Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# altogether with needed tables and stored procedures.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
# The tables and procedures will be located in the current database.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
# @@component_firewall.database will be set to the current database
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# and persisted.
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
# Create tables
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_group_allowlist(
  NAME VARCHAR(288) NOT NULL,
  RULE text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
) engine=InnoDB
--------------

Query OK, 0 rows affected, 2 warnings (0.425 sec)

Warning (Code 1287): 'utf8mb3' is deprecated and will be removed in a future release. Please use utf8mb4 instead
Warning (Code 3778): 'utf8mb3_bin' is a collation of the deprecated character set UTF8MB3. Please consider using UTF8MB4 with an appropriate collation instead.
--------------
CREATE TABLE IF NOT EXISTS firewall_groups(
  NAME VARCHAR(288) PRIMARY KEY,
  MODE ENUM ('OFF', 'RECORDING', 'PROTECTING', 'DETECTING') NOT NULL DEFAULT 'OFF',
  USERHOST VARCHAR(288)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.182 sec)

--------------
CREATE TABLE IF NOT EXISTS firewall_membership(
  GROUP_ID VARCHAR(288),
  MEMBER_ID VARCHAR(288),
  PRIMARY KEY(GROUP_ID, MEMBER_ID)
) engine=InnoDB
--------------

Query OK, 0 rows affected (0.171 sec)

--------------
# install the component
--------------

Query OK, 0 rows affected (0.001 sec)

--------------
INSTALL COMPONENT 'file://component_firewall' SET
  PERSIST component_firewall.database = DATABASE()
--------------

Query OK, 0 rows affected (0.233 sec)

--------------
# Create procedures
--------------

Query OK, 0 rows affected (0.010 sec)

--------------
# switches group operational mode, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_set_firewall_group_mode (IN arg_group_name VARCHAR(288), IN arg_mode varchar(12))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);
  DECLARE reset_done BOOLEAN DEFAULT False;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      # restore the original mode after error
      IF (@prev_mode IS NOT NULL) THEN
        SELECT set_firewall_group_mode(arg_group_name, @prev_mode, IF(@prev_user IS NOT NULL, @prev_user, '')) INTO result;
      END IF;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # reload from permanent storage before switching the mode
  IF arg_mode = "RECORDING" THEN
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE name = arg_group_name;
  END IF;

  # set new mode
  SELECT set_firewall_group_mode(arg_group_name, arg_mode) INTO result;

  # after setting mode to RESET, mode will actually switch to OFF after success
  IF arg_mode = "RESET" THEN
    DELETE FROM firewall_group_allowlist WHERE name = arg_group_name;
    SET arg_mode = "OFF";
    SET reset_done = True;
  END IF;

  # on successful update, update users table information as well
  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, arg_mode, NULL) ON DUPLICATE KEY UPDATE mode = arg_mode;
  ELSE
    SELECT result;
  END IF;

  # update permanent queries list if switching to non-recording mode
  IF arg_mode = "PROTECTING" OR arg_mode = "DETECTING" OR (arg_mode = "OFF" AND reset_done = False) THEN
    INSERT INTO firewall_group_allowlist(name, rule)
    (
      SELECT name, rule FROM performance_schema.firewall_group_allowlist WHERE name=arg_group_name
      EXCEPT
      SELECT name, rule FROM firewall_group_allowlist WHERE name = arg_group_name
    );
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.105 sec)

--------------
# switches group operational mode, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_set_firewall_group_mode_and_user (IN arg_group_name VARCHAR(288), IN arg_mode varchar(12), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);
  DECLARE reset_done BOOLEAN DEFAULT False;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      # restore the original mode after error
      IF (@prev_mode IS NOT NULL) THEN
        SELECT set_firewall_group_mode(arg_group_name, @prev_mode, IF(@prev_user IS NOT NULL, @prev_user, '')) INTO result;
      END IF;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # reload from permanent storage before switching the mode
  IF arg_mode = "RECORDING" THEN
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE name = arg_group_name;
  END IF;

  # set new mode
  SELECT set_firewall_group_mode(arg_group_name, arg_mode, arg_userhost) INTO result;

  # after setting mode to RESET, mode will actually switch to OFF after success
  IF arg_mode = "RESET" THEN
    DELETE FROM firewall_group_allowlist WHERE name = arg_group_name;
    SET arg_mode = "OFF";
    SET reset_done = True;
  END IF;

  # on successful update, update users table information as well
  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, arg_mode, arg_userhost) ON DUPLICATE KEY UPDATE mode=arg_mode, userhost=arg_userhost;
  ELSE
    SELECT result;
  END IF;

  # update permanent queries list if switching to non-recording mode
  IF arg_mode = "PROTECTING" OR arg_mode = "DETECTING" OR (arg_mode = "OFF" AND reset_done = False) THEN
    INSERT INTO firewall_group_allowlist(name, rule)
    (
      SELECT name, rule FROM performance_schema.firewall_group_allowlist WHERE name=arg_group_name
      EXCEPT
      SELECT name, rule FROM firewall_group_allowlist WHERE name = arg_group_name
    );
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.044 sec)

--------------
# rebuilds in-memory cache of particular user firewall rules
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_reload_firewall_group_rules(IN arg_group_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);
  DECLARE prev_mode VARCHAR(12);
  DECLARE prev_user VARCHAR(288);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT 'Reload failed, the cache for the group is in unknown state. Consider reloading the firewall component.';
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  # store the current mode and user before proceeding
  SET @prev_mode = (SELECT mode FROM performance_schema.firewall_groups WHERE name = arg_group_name);
  SET @prev_user = (SELECT userhost FROM performance_schema.firewall_groups WHERE name = arg_group_name);

  # clear query memory cache for particular group
  SELECT set_firewall_group_mode(arg_group_name, "RESET") INTO result;

  IF result = "OK" THEN
    INSERT INTO firewall_groups VALUES (arg_group_name, "OFF", NULL) ON DUPLICATE KEY UPDATE mode="OFF";
    # rebuild cache from permanent query storage
    SELECT read_firewall_group_allowlist(arg_group_name,FW.rule) FROM firewall_group_allowlist FW WHERE FW.name=arg_group_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.045 sec)

--------------
# enlists user to a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_enlist(IN arg_group_name VARCHAR(288), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_delist(arg_group_name, arg_userhost) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_enlist(arg_group_name, arg_userhost) INTO result;
  IF result = "OK" THEN
    INSERT IGNORE INTO firewall_membership VALUES (arg_group_name, arg_userhost);
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.047 sec)

--------------
# removes user from a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_delist(IN arg_group_name VARCHAR(288), IN arg_userhost VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_enlist(arg_group_name, arg_userhost) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_delist(arg_group_name, arg_userhost) INTO result;
  IF result = "OK" THEN
    DELETE IGNORE FROM firewall_membership WHERE group_id = arg_group_name AND member_id = arg_userhost;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.042 sec)

--------------
# renames a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_rename(IN arg_group_old_name VARCHAR(288), IN arg_group_new_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT firewall_group_rename(arg_group_new_name, arg_group_old_name) INTO result;
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_rename(arg_group_old_name, arg_group_new_name) INTO result;
  IF result = "OK" THEN
    UPDATE firewall_groups SET NAME = arg_group_new_name WHERE NAME = arg_group_old_name;
    UPDATE firewall_membership SET GROUP_ID = arg_group_new_name WHERE GROUP_ID = arg_group_old_name;
    UPDATE firewall_group_allowlist SET NAME = arg_group_new_name WHERE NAME = arg_group_old_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.078 sec)

--------------
# removes a group, updates permanent storage accordingly
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
CREATE PROCEDURE IF NOT EXISTS sp_firewall_group_remove(IN arg_group_name VARCHAR(288))
BEGIN
  DECLARE result VARCHAR(160);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SELECT 'Group removal failed, the cache changes cannot be undone, reload the component to reload the cache.';
      ROLLBACK;
      RESIGNAL;
    END;

  START TRANSACTION;

  SELECT firewall_group_remove(arg_group_name) INTO result;
  IF result LIKE "OK%" THEN
    DELETE FROM firewall_group_allowlist WHERE NAME = arg_group_name;
    DELETE FROM firewall_membership WHERE GROUP_ID = arg_group_name;
    DELETE FROM firewall_groups WHERE NAME = arg_group_name;
  ELSE
    SELECT result;
  END IF;

  COMMIT;

END
--------------

Query OK, 0 rows affected (0.049 sec)

Bye
````

### evidence/82-fw-protecting-start.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'PROTECTING')
--------------

Query OK, 0 rows affected (0.174 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+------------+-------------+
| NAME     | MODE       | USERHOST    |
+----------+------------+-------------+
| fw_agent | PROTECTING | ddv_agent@% |
+----------+------------+-------------+
1 row in set (0.007 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME     | RULE                                                                                                                                                                                                                                                                               |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set (0.004 sec)

Bye
````

### evidence/82-fw-recording.txt
````text
--------------
GRANT FIREWALL_ADMIN ON *.* TO 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.194 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_agent', 'RECORDING', 'ddv_agent@%')
--------------

+-------------------------------------------------------+
| read_firewall_group_allowlist(arg_group_name,FW.rule) |
+-------------------------------------------------------+
| Rules added: 0, already existed: 0.                   |
+-------------------------------------------------------+
1 row in set (0.035 sec)

Query OK, 0 rows affected (0.059 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.003 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+----------+-----------+-------------+
| NAME     | MODE      | USERHOST    |
+----------+-----------+-------------+
| fw_agent | RECORDING | ddv_agent@% |
+----------+-----------+-------------+
1 row in set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.010 sec)

Bye
````

### evidence/82-fw-state.txt
````text
--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
|            9 |                  9 | file://component_firewall          |
+--------------+--------------------+------------------------------------+
4 rows in set (0.010 sec)

--------------
SHOW VARIABLES LIKE '%firewall%'
--------------

+--------------------------------------------+---------+
| Variable_name                              | Value   |
+--------------------------------------------+---------+
| component_firewall.database                | ddv_sec |
| component_firewall.enabled                 | ON      |
| component_firewall.reload_interval_seconds | 0       |
| component_firewall.trace                   | OFF     |
+--------------------------------------------+---------+
4 rows in set (0.063 sec)

--------------
SHOW STATUS LIKE '%firewall%'
--------------

+----------------------------------------------------+-------+
| Variable_name                                      | Value |
+----------------------------------------------------+-------+
| firewall_access_denied                             | 0     |
| firewall_access_granted                            | 0     |
| firewall_access_suspicious                         | 0     |
| firewall_cached_entries                            | 0     |
| option_tracker_usage:Enterprise Firewall component | 0     |
+----------------------------------------------------+-------+
5 rows in set (0.026 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
| component_firewall.database     | ddv_sec        |
+---------------------------------+----------------+
2 rows in set (0.011 sec)

--------------
SHOW FULL TABLES FROM ddv_sec
--------------

+--------------------------+------------+
| Tables_in_ddv_sec        | Table_type |
+--------------------------+------------+
| firewall_group_allowlist | BASE TABLE |
| firewall_groups          | BASE TABLE |
| firewall_membership      | BASE TABLE |
+--------------------------+------------+
3 rows in set (0.018 sec)

--------------
SELECT ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'ddv_sec' ORDER BY 2
--------------

+----------------+-------------------------------------+--------------+
| ROUTINE_SCHEMA | ROUTINE_NAME                        | ROUTINE_TYPE |
+----------------+-------------------------------------+--------------+
| ddv_sec        | sp_firewall_group_delist            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_enlist            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_remove            | PROCEDURE    |
| ddv_sec        | sp_firewall_group_rename            | PROCEDURE    |
| ddv_sec        | sp_reload_firewall_group_rules      | PROCEDURE    |
| ddv_sec        | sp_set_firewall_group_mode          | PROCEDURE    |
| ddv_sec        | sp_set_firewall_group_mode_and_user | PROCEDURE    |
+----------------+-------------------------------------+--------------+
7 rows in set (0.042 sec)

--------------
SHOW GRANTS FOR CURRENT_USER()
--------------

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for root@localhost                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| GRANT ALLOW_NONEXISTENT_DEFINER,APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,CREATE_SPATIAL_REFERENCE_SYSTEM,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_PRIVILEGES,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,MANAGE_DATA_MASKING_POLICY,OPTIMIZE_LOCAL_TABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_ANY_DEFINER,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,TRANSACTION_GTID_TAG,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION |
| GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
3 rows in set (0.006 sec)

--------------
SHOW PRIVILEGES
--------------

+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
| Privilege                       | Context                               | Comment                                                         |
+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
| Alter                           | Tables                                | To alter the table                                              |
| Alter routine                   | Functions,Procedures                  | To alter or drop stored functions/procedures                    |
| Create                          | Databases,Tables,Indexes              | To create new databases and tables                              |
| Create routine                  | Databases                             | To use CREATE FUNCTION/PROCEDURE                                |
| Create role                     | Server Admin                          | To create new roles                                             |
| Create temporary tables         | Databases                             | To use CREATE TEMPORARY TABLE                                   |
| Create view                     | Tables                                | To create new views                                             |
| Create user                     | Server Admin                          | To create new users                                             |
| Delete                          | Tables                                | To delete existing rows                                         |
| Drop                            | Databases,Tables                      | To drop databases, tables, and views                            |
| Drop role                       | Server Admin                          | To drop roles                                                   |
| Event                           | Server Admin                          | To create, alter, drop and execute events                       |
| Execute                         | Functions,Procedures                  | To execute stored routines                                      |
| File                            | File access on server                 | To read and write files on the server                           |
| Grant option                    | Databases,Tables,Functions,Procedures | To give to other users those privileges you possess             |
| Index                           | Tables                                | To create or drop indexes                                       |
| Insert                          | Tables                                | To insert data into tables                                      |
| Lock tables                     | Databases                             | To use LOCK TABLES (together with SELECT privilege)             |
| Process                         | Server Admin                          | To view the plain text of currently executing queries           |
| Proxy                           | Server Admin                          | To make proxy user possible                                     |
| References                      | Databases,Tables                      | To have references on tables                                    |
| Reload                          | Server Admin                          | To reload or refresh tables, logs and privileges                |
| Replication client              | Server Admin                          | To ask where the slave or master servers are                    |
| Replication slave               | Server Admin                          | To read binary log events from the master                       |
| Select                          | Tables                                | To retrieve rows from table                                     |
| Show databases                  | Server Admin                          | To see all databases with SHOW DATABASES                        |
| Show view                       | Tables                                | To see views with SHOW CREATE VIEW                              |
| Shutdown                        | Server Admin                          | To shut down the server                                         |
| Super                           | Server Admin                          | To use KILL thread, SET GLOBAL, CHANGE REPLICATION SOURCE, etc. |
| Trigger                         | Tables                                | To use triggers                                                 |
| Create tablespace               | Server Admin                          | To create/alter/drop tablespaces                                |
| Update                          | Tables                                | To update existing rows                                         |
| Usage                           | Server Admin                          | No privileges - allow connect only                              |
| INNODB_REDO_LOG_ARCHIVE         | Server Admin                          |                                                                 |
| ENCRYPTION_KEY_ADMIN            | Server Admin                          |                                                                 |
| MASKING_DICTIONARIES_ADMIN      | Server Admin                          |                                                                 |
| TABLE_ENCRYPTION_ADMIN          | Server Admin                          |                                                                 |
| ROLE_ADMIN                      | Server Admin                          |                                                                 |
| REPLICATION_SLAVE_ADMIN         | Server Admin                          |                                                                 |
| SYSTEM_VARIABLES_ADMIN          | Server Admin                          |                                                                 |
| BINLOG_ADMIN                    | Server Admin                          |                                                                 |
| SERVICE_CONNECTION_ADMIN        | Server Admin                          |                                                                 |
| GROUP_REPLICATION_ADMIN         | Server Admin                          |                                                                 |
| CONNECTION_ADMIN                | Server Admin                          |                                                                 |
| PASSWORDLESS_USER_ADMIN         | Server Admin                          |                                                                 |
| XA_RECOVER_ADMIN                | Server Admin                          |                                                                 |
| PERSIST_RO_VARIABLES_ADMIN      | Server Admin                          |                                                                 |
| SHOW_ROUTINE                    | Server Admin                          |                                                                 |
| BACKUP_ADMIN                    | Server Admin                          |                                                                 |
| GROUP_REPLICATION_STREAM        | Server Admin                          |                                                                 |
| CLONE_ADMIN                     | Server Admin                          |                                                                 |
| FIREWALL_ADMIN                  | Server Admin                          |                                                                 |
| OPTIMIZE_LOCAL_TABLE            | Server Admin                          |                                                                 |
| SESSION_VARIABLES_ADMIN         | Server Admin                          |                                                                 |
| RESOURCE_GROUP_ADMIN            | Server Admin                          |                                                                 |
| FIREWALL_EXEMPT                 | Server Admin                          |                                                                 |
| RESOURCE_GROUP_USER             | Server Admin                          |                                                                 |
| BINLOG_ENCRYPTION_ADMIN         | Server Admin                          |                                                                 |
| APPLICATION_PASSWORD_ADMIN      | Server Admin                          |                                                                 |
| SYSTEM_USER                     | Server Admin                          |                                                                 |
| FLUSH_OPTIMIZER_COSTS           | Server Admin                          |                                                                 |
| TELEMETRY_LOG_ADMIN             | Server Admin                          |                                                                 |
| INNODB_REDO_LOG_ENABLE          | Server Admin                          |                                                                 |
| REPLICATION_APPLIER             | Server Admin                          |                                                                 |
| CREATE_SPATIAL_REFERENCE_SYSTEM | Server Admin                          |                                                                 |
| FLUSH_STATUS                    | Server Admin                          |                                                                 |
| FLUSH_USER_RESOURCES            | Server Admin                          |                                                                 |
| FLUSH_TABLES                    | Server Admin                          |                                                                 |
| SET_ANY_DEFINER                 | Server Admin                          |                                                                 |
| FLUSH_PRIVILEGES                | Server Admin                          |                                                                 |
| AUTHENTICATION_POLICY_ADMIN     | Server Admin                          |                                                                 |
| SENSITIVE_VARIABLES_OBSERVER    | Server Admin                          |                                                                 |
| ALLOW_NONEXISTENT_DEFINER       | Server Admin                          |                                                                 |
| TRANSACTION_GTID_TAG            | Server Admin                          |                                                                 |
| MANAGE_DATA_MASKING_POLICY      | Server Admin                          |                                                                 |
+---------------------------------+---------------------------------------+-----------------------------------------------------------------+
75 rows in set (0.006 sec)

Bye
````

### evidence/82-fw-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.008 sec)

--------------
# This script uninstalls Enterprise Firewall component
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
# and drops its tables and stored procedures.
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
#
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
# NOTE: before running the script the following must be assured:
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# 1) there is only a single connection (current)
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
# 2) the current database is @@component_firewall.database
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
UNINSTALL COMPONENT 'file://component_firewall'
--------------

Query OK, 0 rows affected (0.789 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode
--------------

Query OK, 0 rows affected (0.095 sec)

--------------
DROP PROCEDURE sp_set_firewall_group_mode_and_user
--------------

Query OK, 0 rows affected (0.066 sec)

--------------
DROP PROCEDURE sp_reload_firewall_group_rules
--------------

Query OK, 0 rows affected (0.061 sec)

--------------
DROP PROCEDURE sp_firewall_group_enlist
--------------

Query OK, 0 rows affected (0.059 sec)

--------------
DROP PROCEDURE sp_firewall_group_delist
--------------

Query OK, 0 rows affected (0.065 sec)

--------------
DROP PROCEDURE sp_firewall_group_rename
--------------

Query OK, 0 rows affected (0.050 sec)

--------------
DROP PROCEDURE sp_firewall_group_remove
--------------

Query OK, 0 rows affected (0.077 sec)

--------------
DROP TABLE firewall_group_allowlist
--------------

Query OK, 0 rows affected (0.248 sec)

--------------
DROP TABLE firewall_groups
--------------

Query OK, 0 rows affected (0.344 sec)

--------------
DROP TABLE firewall_membership
--------------

Query OK, 0 rows affected (0.210 sec)

Bye
````

### evidence/82-groups-teardown.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_agent', 'RESET')
--------------

Query OK, 0 rows affected (0.231 sec)

--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_norole', 'RESET')
--------------

Query OK, 0 rows affected (0.070 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+-----------+------+--------------+
| NAME      | MODE | USERHOST     |
+-----------+------+--------------+
| fw_agent  | OFF  | ddv_agent@%  |
| fw_norole | OFF  | ddv_norole@% |
+-----------+------+--------------+
2 rows in set (0.005 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

Empty set (0.013 sec)

--------------
CALL ddv_sec.sp_firewall_group_delist('fw_agent', 'ddv_agent@%')
--------------

Query OK, 0 rows affected (0.062 sec)

--------------
CALL ddv_sec.sp_firewall_group_delist('fw_norole', 'ddv_norole@%')
--------------

Query OK, 0 rows affected (0.060 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.011 sec)

--------------
CALL ddv_sec.sp_firewall_group_remove('fw_agent')
--------------

Query OK, 0 rows affected (0.054 sec)

--------------
CALL ddv_sec.sp_firewall_group_remove('fw_norole')
--------------

Query OK, 0 rows affected (0.051 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

Empty set (0.009 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

Empty set (0.009 sec)

--------------
REVOKE FIREWALL_ADMIN ON *.* FROM 'root'@'localhost'
--------------

Query OK, 0 rows affected (0.058 sec)

--------------
SHOW GRANTS FOR CURRENT_USER()
--------------

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for root@localhost                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| GRANT ALLOW_NONEXISTENT_DEFINER,APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,CREATE_SPATIAL_REFERENCE_SYSTEM,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_PRIVILEGES,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,MANAGE_DATA_MASKING_POLICY,OPTIMIZE_LOCAL_TABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_ANY_DEFINER,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,TRANSACTION_GTID_TAG,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION |
| GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
3 rows in set (0.011 sec)

Bye
````

### evidence/82-inject-literal.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'x'' OR ''1''=''1'
--------------

Empty set (0.008 sec)

Bye
````

### evidence/82-inject-literal-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 18    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.015 sec)

Bye
````

### evidence/82-inject-literal-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 6     |
| firewall_access_granted    | 17    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.010 sec)

Bye
````

### evidence/82-inject-or.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'x' OR '1'='1'
--------------

ERROR 6444 (28000) at line 1: Access denied.
ERROR 6444 (28000) at line 1: Access denied.
ERROR 6444 (28000) at line 1: Access denied.
Bye
````

### evidence/82-inject-or-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 6     |
| firewall_access_granted    | 17    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/82-inject-or-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 3     |
| firewall_access_granted    | 17    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.009 sec)

Bye
````

### evidence/82-norole-find-customer.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Bilal Sample'
--------------

ERROR 6444 (28000) at line 1: Access denied.
ERROR 6444 (28000) at line 1: Access denied.
ERROR 2014 (HY000) at line 1: Commands out of sync; you can't run this command now
Bye
````

### evidence/82-norole-find-customer-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 9     |
| firewall_access_granted    | 23    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.036 sec)

Bye
````

### evidence/82-norole-find-customer-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 22    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.027 sec)

Bye
````

### evidence/82-norole-group.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode_and_user('fw_norole', 'RECORDING', 'ddv_norole@%')
--------------

+-------------------------------------------------------+
| read_firewall_group_allowlist(arg_group_name,FW.rule) |
+-------------------------------------------------------+
| Rules added: 0, already existed: 0.                   |
+-------------------------------------------------------+
1 row in set (0.015 sec)

Query OK, 0 rows affected (0.059 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.002 sec)

--------------
CALL ddv_sec.sp_firewall_group_enlist('fw_norole', 'ddv_norole@%')
--------------

Query OK, 0 rows affected (0.038 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+-----------+------------+--------------+
| NAME      | MODE       | USERHOST     |
+-----------+------------+--------------+
| fw_agent  | PROTECTING | ddv_agent@%  |
| fw_norole | RECORDING  | ddv_norole@% |
+-----------+------------+--------------+
2 rows in set (0.009 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+-----------+--------------+
| GROUP_ID  | MEMBER_ID    |
+-----------+--------------+
| fw_agent  | ddv_agent@%  |
| fw_norole | ddv_norole@% |
+-----------+--------------+
2 rows in set (0.007 sec)

Bye
````

### evidence/82-norole-protecting.txt
````text
--------------
CALL ddv_sec.sp_set_firewall_group_mode('fw_norole', 'PROTECTING')
--------------

Query OK, 0 rows affected (0.190 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+-----------+------------+--------------+
| NAME      | MODE       | USERHOST     |
+-----------+------------+--------------+
| fw_agent  | PROTECTING | ddv_agent@%  |
| fw_norole | PROTECTING | ddv_norole@% |
+-----------+------------+--------------+
2 rows in set (0.004 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist WHERE NAME = 'fw_norole'
--------------

+-----------+--------------------------------------------------+
| NAME      | RULE                                             |
+-----------+--------------------------------------------------+
| fw_norole | SELECT @@`version_comment` LIMIT ?               |
| fw_norole | SELECT COUNT ( * ) FROM `ddv_support` . `orders` |
+-----------+--------------------------------------------------+
2 rows in set (0.006 sec)

Bye
````

### evidence/82-norole-record.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.019 sec)

Bye
````

### evidence/82-norole-recorded-shape.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.009 sec)

Bye
````

### evidence/82-norole-recorded-shape-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 22    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.014 sec)

Bye
````

### evidence/82-norole-recorded-shape-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 7     |
| firewall_access_granted    | 20    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 10    |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/82-recording-run.txt
````text
=== Question 1: Where is order 102?
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: list_orders(1) -> 2 row(s)
    {'id': 101, 'status': 'delivered', 'total_amount': Decimal('1250.00'), 'created_at': datetime.datetime(2026, 9, 1, 10, 15)}
    {'id': 102, 'status': 'shipped', 'total_amount': Decimal('349.50'), 'created_at': datetime.datetime(2026, 9, 20, 14, 2)}
tool call: payment_status(102) -> 1 row(s)
    {'id': 1002, 'order_id': 102, 'method': 'upi', 'card_number': None, 'upi_id': 'a************', 'status': 'captured', 'order_status': 'shipped'}
=== Question 2: Verify caller Asha Example with last four 0101
tool call: find_customer('Asha Example') -> 1 row(s)
    {'id': 1, 'full_name': 'Asha Example', 'phone': '****0101', 'email': 'a***********@example.test', 'tax_id': '*********'}
tool call: verify_last4(1, '0101') -> 1 row(s)
    {'matches': 1}
=== Question 3: Why did Chen Demo's charge fail?
tool call: find_customer('Chen Demo') -> 1 row(s)
    {'id': 3, 'full_name': 'Chen Demo', 'phone': '****0103', 'email': 'c********@example.test', 'tax_id': '*********'}
tool call: list_orders(3) -> 2 row(s)
    {'id': 105, 'status': 'pending', 'total_amount': Decimal('45.00'), 'created_at': datetime.datetime(2026, 10, 2, 11, 5)}
    {'id': 106, 'status': 'delivered', 'total_amount': Decimal('310.75'), 'created_at': datetime.datetime(2026, 9, 28, 18, 30)}
tool call: payment_status(105) -> 1 row(s)
    {'id': 1005, 'order_id': 105, 'method': 'upi', 'card_number': None, 'upi_id': 'c************', 'status': 'pending', 'order_status': 'pending'}
tool call: payment_status(106) -> 1 row(s)
    {'id': 1006, 'order_id': 106, 'method': 'card', 'card_number': '***********0005', 'upi_id': None, 'status': 'captured', 'order_status': 'delivered'}
tool call: ticket_notes(3) -> 1 row(s)
    {'id': 3, 'subject': 'Charge failed, please call back', 'notes': 'Customer typed: my card is 378282246310005 and you can reach me at chen.demo@example.test, please retry the charge.'}
=== Question 4: What is the refund status of order 104?
tool call: payment_status(104) -> 1 row(s)
    {'id': 1004, 'order_id': 104, 'method': 'card', 'card_number': '************4444', 'upi_id': None, 'status': 'refunded', 'order_status': 'refunded'}
context written to evidence/82-ctx.txt
````

### evidence/82-reset-persist.txt
````text
--------------
RESET PERSIST component_firewall.database
--------------

Query OK, 0 rows affected (0.208 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.010 sec)

Bye
````

### evidence/82-schema-create.txt
````text
--------------
CREATE SCHEMA ddv_sec
--------------

Query OK, 1 row affected (0.211 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.007 sec)

Bye
````

### evidence/82-shape-bilal.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Bilal Sample'
--------------

+----+--------------+----------+---------------------------+-----------+
| id | full_name    | phone    | email                     | tax_id    |
+----+--------------+----------+---------------------------+-----------+
|  2 | Bilal Sample | ****0102 | b***********@example.test | ********* |
+----+--------------+----------+---------------------------+-----------+
1 row in set (0.009 sec)

Bye
````

### evidence/82-shape-bilal-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 1     |
| firewall_access_granted    | 15    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.022 sec)

Bye
````

### evidence/82-shape-bilal-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 0     |
| firewall_access_granted    | 14    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.017 sec)

Bye
````

### evidence/82-shape-chen.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Chen Demo'
--------------

+----+-----------+----------+------------------------+-----------+
| id | full_name | phone    | email                  | tax_id    |
+----+-----------+----------+------------------------+-----------+
|  3 | Chen Demo | ****0103 | c********@example.test | ********* |
+----+-----------+----------+------------------------+-----------+
1 row in set (0.007 sec)

Bye
````

### evidence/82-shape-chen-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 2     |
| firewall_access_granted    | 16    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.010 sec)

Bye
````

### evidence/82-shape-chen-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 1     |
| firewall_access_granted    | 15    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.014 sec)

Bye
````

### evidence/82-shape-nobody.txt
````text
--------------
SELECT id, full_name, phone, email, tax_id FROM ddv_support.customers WHERE full_name = 'Nobody Here'
--------------

Empty set (0.008 sec)

Bye
````

### evidence/82-shape-nobody-status-after.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 3     |
| firewall_access_granted    | 17    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.029 sec)

Bye
````

### evidence/82-shape-nobody-status-before.txt
````text
--------------
SHOW GLOBAL STATUS LIKE 'firewall%'
--------------

+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| firewall_access_denied     | 2     |
| firewall_access_granted    | 16    |
| firewall_access_suspicious | 0     |
| firewall_cached_entries    | 8     |
+----------------------------+-------+
4 rows in set (0.011 sec)

Bye
````

### evidence/82-teardown-precheck.txt
````text
--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 332 | root            | localhost:60285 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.153 sec)

Warning (Code 1287): 'INFORMATION_SCHEMA.PROCESSLIST' is deprecated and will be removed in a future release. Please use performance_schema.processlist instead
--------------
SELECT * FROM performance_schema.firewall_groups
--------------

+-----------+------------+--------------+
| NAME      | MODE       | USERHOST     |
+-----------+------------+--------------+
| fw_agent  | DETECTING  | ddv_agent@%  |
| fw_norole | PROTECTING | ddv_norole@% |
+-----------+------------+--------------+
2 rows in set (0.011 sec)

--------------
SELECT * FROM performance_schema.firewall_membership
--------------

+-----------+--------------+
| GROUP_ID  | MEMBER_ID    |
+-----------+--------------+
| fw_agent  | ddv_agent@%  |
| fw_norole | ddv_norole@% |
+-----------+--------------+
2 rows in set (0.009 sec)

--------------
SELECT * FROM performance_schema.firewall_group_allowlist
--------------

+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NAME      | RULE                                                                                                                                                                                                                                                                               |
+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fw_agent  | SELECT @@SESSION . `sql_mode`                                                                                                                                                                                                                                                      |
| fw_agent  | SELECT RIGHT ( `phone` , ? ) = ? AS `matches` FROM `ddv_support` . `customers` WHERE `id` = ?                                                                                                                                                                                      |
| fw_agent  | SELECT `id` , STATUS , `total_amount` , `created_at` FROM `ddv_support` . `orders` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                           |
| fw_agent  | SELECT `id` , SUBJECT , `notes` FROM `ddv_support` . `support_tickets` WHERE `customer_id` = ? ORDER BY `id`                                                                                                                                                                       |
| fw_agent  | SELECT `id` , `full_name` , `phone` , `email` , `tax_id` FROM `ddv_support` . `customers` WHERE `full_name` = ?                                                                                                                                                                    |
| fw_agent  | SELECT `p` . `id` , `p` . `order_id` , `p` . `method` , `p` . `card_number` , `p` . `upi_id` , `p` . `status` , `o` . `status` AS `order_status` FROM `ddv_support` . `payments` `p` JOIN `ddv_support` . `orders` `o` ON `o` . `id` = `p` . `order_id` WHERE `p` . `order_id` = ? |
| fw_agent  | SET @@SESSION . `autocommit` = OFF                                                                                                                                                                                                                                                 |
| fw_agent  | SET NAMES ? COLLATE ?                                                                                                                                                                                                                                                              |
| fw_norole | SELECT @@`version_comment` LIMIT ?                                                                                                                                                                                                                                                 |
| fw_norole | SELECT COUNT ( * ) FROM `ddv_support` . `orders`                                                                                                                                                                                                                                   |
+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
10 rows in set (0.009 sec)

Bye
````

### evidence/83-audit-extract.txt
````text
Extract of audit_log_read output (36 events, from the server-start event of this run, read in pages of 40). Raw JSON not saved: it contained a local path, the machine name and the OS user name. Kept per event: class/event, account, command class, status, statement text. Timestamps, ids, IP, OS user and connection attributes are omitted.
n | class/event | account | command class | status | statement text
1 | audit/startup | root@localhost | (server startup) |  | 
2 | connection/connect | ddv_agent@localhost | ssl | 0 | 
3 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
4 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
5 | general/status | ddv_agent@localhost | Query/show_status | 0 | SHOW STATUS LIKE 'audit_log%'
6 | connection/disconnect | ddv_agent@localhost | ssl |  | 
7 | connection/connect | ddv_billing@localhost | ssl | 0 | 
8 | general/status | ddv_billing@localhost | Query/select | 0 | select @@version_comment limit 1
9 | general/status | ddv_billing@localhost | Query/error | 1064 | select $$
10 | general/status | ddv_billing@localhost | Query/show_status | 0 | SHOW STATUS LIKE 'audit_log%'
11 | connection/disconnect | ddv_billing@localhost | ssl |  | 
12 | connection/connect | ddv_agent@localhost | ssl | 0 | 
13 | general/status | ddv_agent@localhost | Query/select | 0 | select @@version_comment limit 1
14 | general/status | ddv_agent@localhost | Query/error | 1064 | select $$
15 | table_access/read | ddv_agent@localhost | select |  | SELECT COUNT(*) FROM ddv_support.orders
16 | general/status | ddv_agent@localhost | Query/select | 0 | SELECT COUNT(*) FROM ddv_support.orders
17 | connection/disconnect | ddv_agent@localhost | ssl |  | 
18 | connection/connect | ddv_billing@localhost | ssl | 0 | 
19 | general/status | ddv_billing@localhost | Query/select | 0 | select @@version_comment limit 1
20 | general/status | ddv_billing@localhost | Query/error | 1064 | select $$
21 | table_access/read | ddv_billing@localhost | select |  | SELECT COUNT(*) FROM ddv_support.orders
22 | general/status | ddv_billing@localhost | Query/select | 0 | SELECT COUNT(*) FROM ddv_support.orders
23 | connection/disconnect | ddv_billing@localhost | ssl |  | 
24 | connection/connect | root@localhost | ssl | 0 | 
25 | general/status | root@localhost | Query/select | 0 | select @@version_comment limit 1
26 | general/status | root@localhost | Query/error | 1064 | select $$
27 | general/status | root@localhost | Query/create_user | 0 | CREATE USER 'ddv_pwtest'@'%' IDENTIFIED BY <secret>
28 | general/status | root@localhost | Query/alter_user | 0 | ALTER USER 'ddv_pwtest'@'%' IDENTIFIED BY <secret>
29 | general/status | root@localhost | Query/set_password | 0 | SET PASSWORD FOR `ddv_pwtest`@`%`=<secret>
30 | general/status | root@localhost | Query/select | 0 | SELECT 'SENTINEL-FAKE-PW-0004'
31 | connection/disconnect | root@localhost | ssl |  | 
32 | connection/connect | root@localhost | ssl | 0 | 
33 | general/status | root@localhost | Query/select | 0 | select @@version_comment limit 1
34 | general/status | root@localhost | Query/error | 1064 | select $$
35 | general/status | root@localhost | Query/select | 0 | SELECT audit_log_filter_remove_user('root@localhost')
36 | connection/disconnect | root@localhost | ssl |  | 
````

### evidence/83-audit-install.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.010 sec)

--------------
CREATE TABLE IF NOT EXISTS audit_log_filter(NAME VARCHAR(64) BINARY NOT NULL PRIMARY KEY, FILTER JSON NOT NULL) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 1 warning (0.613 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
CREATE TABLE IF NOT EXISTS audit_log_user(USER VARCHAR(32) BINARY NOT NULL, HOST VARCHAR(255) CHARACTER SET ASCII NOT NULL, FILTERNAME VARCHAR(64) BINARY NOT NULL, PRIMARY KEY (USER, HOST), FOREIGN KEY (FILTERNAME) REFERENCES audit_log_filter(NAME)) engine= InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci
--------------

Query OK, 0 rows affected, 2 warnings (1.034 sec)

Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
Warning (Code 1287): 'BINARY as attribute of a type' is deprecated and will be removed in a future release. Please use a CHARACTER SET clause with _bin collation instead
--------------
INSTALL COMPONENT "file://component_audit_log"
--------------

Query OK, 0 rows affected (0.439 sec)

Bye
````

### evidence/83-audit-remove.txt
````text
--------------
DROP USER 'ddv_pwtest'@'%'
--------------

Query OK, 0 rows affected (0.120 sec)

--------------
SELECT audit_log_filter_remove_user('ddv_agent@%')
--------------

+---------------------------------------------+
| audit_log_filter_remove_user('ddv_agent@%') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.060 sec)

--------------
SELECT audit_log_filter_remove_user('ddv_billing@%')
--------------

+-----------------------------------------------+
| audit_log_filter_remove_user('ddv_billing@%') |
+-----------------------------------------------+
| OK                                            |
+-----------------------------------------------+
1 row in set (0.042 sec)

--------------
SELECT audit_log_filter_remove_filter('agent_log')
--------------

+---------------------------------------------+
| audit_log_filter_remove_filter('agent_log') |
+---------------------------------------------+
| OK                                          |
+---------------------------------------------+
1 row in set (0.035 sec)

--------------
SELECT audit_log_filter_remove_filter('billing_log')
--------------

+-----------------------------------------------+
| audit_log_filter_remove_filter('billing_log') |
+-----------------------------------------------+
| OK                                            |
+-----------------------------------------------+
1 row in set (0.031 sec)

--------------
SELECT audit_log_filter_remove_filter('root_log')
--------------

+--------------------------------------------+
| audit_log_filter_remove_filter('root_log') |
+--------------------------------------------+
| OK                                         |
+--------------------------------------------+
1 row in set (0.032 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

Empty set (0.004 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

Empty set (0.004 sec)

--------------
SHOW STATUS LIKE 'audit_log.events%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.events               | 311   |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 36    |
+--------------------------------+-------+
6 rows in set (0.014 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
| 364 | root            | localhost:53696 | Query   |
|   7 | event_scheduler | localhost       | Daemon  |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.017 sec)

Warning (Code 1287): 'INFORMATION_SCHEMA.PROCESSLIST' is deprecated and will be removed in a future release. Please use performance_schema.processlist instead
Bye
````

### evidence/83-audit-uninstall.txt
````text
--------------
# Copyright (c) 2025, 2026, Oracle and/or its affiliates.
--------------

Query OK, 0 rows affected (0.007 sec)

--------------
-- Audit Log Uninstallation script
--------------

Query OK, 0 rows affected (0.005 sec)

--------------
-- 1. Drops the functions.
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
-- 2. Drops the tables.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
-- 3. Uninstalls the component.
--------------

Query OK, 0 rows affected (0.002 sec)

--------------
-- Note: Please specify the schema name before
--------------

Query OK, 0 rows affected (0.004 sec)

--------------
-- running the script using either -D or --database.
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
-- Uninstall the component.
--------------

Query OK, 0 rows affected (0.007 sec)

--------------
UNINSTALL COMPONENT "file://component_audit_log"
--------------

Query OK, 0 rows affected (0.087 sec)

--------------
-- Drop the tables.
--------------

Query OK, 0 rows affected (0.003 sec)

--------------
DROP TABLE IF EXISTS audit_log_user
--------------

Query OK, 0 rows affected (0.188 sec)

--------------
DROP TABLE IF EXISTS audit_log_filter
--------------

Query OK, 0 rows affected (0.144 sec)

Bye
````

### evidence/83-filters.txt
````text
--------------
SELECT audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }')
--------------

+---------------------------------------------------------------------------+
| audit_log_filter_set_filter('agent_log', '{ "filter": { "log": true } }') |
+---------------------------------------------------------------------------+
| OK                                                                        |
+---------------------------------------------------------------------------+
1 row in set (0.096 sec)

--------------
SELECT audit_log_filter_set_user('ddv_agent@%', 'agent_log')
--------------

+-------------------------------------------------------+
| audit_log_filter_set_user('ddv_agent@%', 'agent_log') |
+-------------------------------------------------------+
| OK                                                    |
+-------------------------------------------------------+
1 row in set (0.076 sec)

--------------
SELECT audit_log_filter_set_filter('billing_log', '{ "filter": { "log": true } }')
--------------

+-----------------------------------------------------------------------------+
| audit_log_filter_set_filter('billing_log', '{ "filter": { "log": true } }') |
+-----------------------------------------------------------------------------+
| OK                                                                          |
+-----------------------------------------------------------------------------+
1 row in set (0.066 sec)

--------------
SELECT audit_log_filter_set_user('ddv_billing@%', 'billing_log')
--------------

+-----------------------------------------------------------+
| audit_log_filter_set_user('ddv_billing@%', 'billing_log') |
+-----------------------------------------------------------+
| OK                                                        |
+-----------------------------------------------------------+
1 row in set (0.080 sec)

--------------
SELECT * FROM mysql.audit_log_filter
--------------

+-------------+---------------------------+
| NAME        | FILTER                    |
+-------------+---------------------------+
| agent_log   | {"filter": {"log": true}} |
| billing_log | {"filter": {"log": true}} |
+-------------+---------------------------+
2 rows in set (0.019 sec)

--------------
SELECT * FROM mysql.audit_log_user
--------------

+-------------+------+-------------+
| USER        | HOST | FILTERNAME  |
+-------------+------+-------------+
| ddv_agent   | %    | agent_log   |
| ddv_billing | %    | billing_log |
+-------------+------+-------------+
2 rows in set (0.016 sec)

Bye
````

### evidence/83-pw-statements.txt
````text
--------------
CREATE USER 'ddv_pwtest'@'%' IDENTIFIED BY 'SENTINEL-FAKE-PW-0001'
--------------

Query OK, 0 rows affected (0.255 sec)

--------------
ALTER USER 'ddv_pwtest'@'%' IDENTIFIED BY 'SENTINEL-FAKE-PW-0002'
--------------

Query OK, 0 rows affected (0.136 sec)

--------------
SET PASSWORD FOR 'ddv_pwtest'@'%' = 'SENTINEL-FAKE-PW-0003'
--------------

Query OK, 0 rows affected (0.081 sec)

--------------
SELECT 'SENTINEL-FAKE-PW-0004'
--------------

+-----------------------+
| SENTINEL-FAKE-PW-0004 |
+-----------------------+
| SENTINEL-FAKE-PW-0004 |
+-----------------------+
1 row in set (0.004 sec)

Bye
````

### evidence/83-root-filter.txt
````text
--------------
SELECT audit_log_filter_set_filter('root_log', '{ "filter": { "log": true } }')
--------------

+--------------------------------------------------------------------------+
| audit_log_filter_set_filter('root_log', '{ "filter": { "log": true } }') |
+--------------------------------------------------------------------------+
| OK                                                                       |
+--------------------------------------------------------------------------+
1 row in set (0.194 sec)

--------------
SELECT audit_log_filter_set_user('root@localhost', 'root_log')
--------------

+---------------------------------------------------------+
| audit_log_filter_set_user('root@localhost', 'root_log') |
+---------------------------------------------------------+
| OK                                                      |
+---------------------------------------------------------+
1 row in set (0.059 sec)

Bye
````

### evidence/83-root-unassign.txt
````text
--------------
SELECT audit_log_filter_remove_user('root@localhost')
--------------

+------------------------------------------------+
| audit_log_filter_remove_user('root@localhost') |
+------------------------------------------------+
| OK                                             |
+------------------------------------------------+
1 row in set (0.039 sec)

Bye
````

### evidence/83-select-agent.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.025 sec)

Bye
````

### evidence/83-select-billing.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.017 sec)

Bye
````

### evidence/83-select-norole.txt
````text
--------------
SELECT COUNT(*) FROM ddv_support.orders
--------------

+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.022 sec)

Bye
````

### evidence/83-status-agent.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 1712  |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 57    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 4     |
| audit_log.file_count           | 3     |
| audit_log.filter_id            | 1     |
| audit_log.total_size           | 98379 |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.031 sec)

Bye
````

### evidence/83-status-billing.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+--------+
| Variable_name                  | Value  |
+--------------------------------+--------+
| audit_log.current_size         | 3626   |
| audit_log.event_max_drop_size  | 0      |
| audit_log.events               | 71     |
| audit_log.events_buffered      | 0      |
| audit_log.events_direct_writes | 0      |
| audit_log.events_filtered      | 0      |
| audit_log.events_lost          | 0      |
| audit_log.events_written       | 9      |
| audit_log.file_count           | 3      |
| audit_log.filter_id            | 2      |
| audit_log.total_size           | 100293 |
| audit_log.write_waits          | 0      |
+--------------------------------+--------+
12 rows in set (0.028 sec)

Bye
````

### evidence/83-status-norole.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+--------+
| Variable_name                  | Value  |
+--------------------------------+--------+
| audit_log.current_size         | 4301   |
| audit_log.event_max_drop_size  | 0      |
| audit_log.events               | 84     |
| audit_log.events_buffered      | 0      |
| audit_log.events_direct_writes | 0      |
| audit_log.events_filtered      | 0      |
| audit_log.events_lost          | 0      |
| audit_log.events_written       | 11     |
| audit_log.file_count           | 3      |
| audit_log.filter_id            | 0      |
| audit_log.total_size           | 100968 |
| audit_log.write_waits          | 0      |
+--------------------------------+--------+
12 rows in set (0.035 sec)

Bye
````

### evidence/83-status-root.txt
````text
--------------
SHOW STATUS LIKE 'audit_log%'
--------------

+--------------------------------+-------+
| Variable_name                  | Value |
+--------------------------------+-------+
| audit_log.current_size         | 477   |
| audit_log.event_max_drop_size  | 0     |
| audit_log.events               | 43    |
| audit_log.events_buffered      | 0     |
| audit_log.events_direct_writes | 0     |
| audit_log.events_filtered      | 0     |
| audit_log.events_lost          | 0     |
| audit_log.events_written       | 1     |
| audit_log.file_count           | 3     |
| audit_log.filter_id            | 0     |
| audit_log.total_size           | 97144 |
| audit_log.write_waits          | 0     |
+--------------------------------+-------+
12 rows in set (0.043 sec)

Bye
````

### evidence/84-after.txt
````text
--------------
SELECT * FROM mysql.component
--------------

+--------------+--------------------+------------------------------------+
| component_id | component_group_id | component_urn                      |
+--------------+--------------------+------------------------------------+
|            1 |                  1 | file://component_masking           |
|            2 |                  2 | file://component_masking_functions |
|            3 |                  3 | file://component_object_policy     |
+--------------+--------------------+------------------------------------+
3 rows in set (0.008 sec)

--------------
SHOW TABLES FROM mysql LIKE 'audit%'
--------------

Empty set (0.048 sec)

--------------
SHOW VARIABLES LIKE 'audit_log%'
--------------

Empty set (0.088 sec)

--------------
SELECT * FROM performance_schema.persisted_variables
--------------

+---------------------------------+----------------+
| VARIABLE_NAME                   | VARIABLE_VALUE |
+---------------------------------+----------------+
| log_bin_trust_function_creators | ON             |
+---------------------------------+----------------+
1 row in set (0.006 sec)

--------------
SELECT ID, USER, HOST, COMMAND FROM information_schema.PROCESSLIST
--------------

+-----+-----------------+-----------------+---------+
| ID  | USER            | HOST            | COMMAND |
+-----+-----------------+-----------------+---------+
|   7 | event_scheduler | localhost       | Daemon  |
| 375 | root            | localhost:62091 | Query   |
+-----+-----------------+-----------------+---------+
2 rows in set, 1 warning (0.149 sec)

Bye
````

### evidence/84-cleanup.txt
````text
--------------
REVOKE SELECT, ALTER, INSERT, UPDATE ON ddv_probe4.probe_alter FROM 'ddv_alterer'@'%'
--------------

Query OK, 0 rows affected (0.232 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.012 sec)

--------------
REVOKE SELECT ON ddv_probe4.probe_people FROM 'ddv_agent'@'%'
--------------

Query OK, 0 rows affected (0.079 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.007 sec)

--------------
REVOKE SELECT ON ddv_probe4.probe_people FROM 'ddv_billing'@'%'
--------------

Query OK, 0 rows affected (0.072 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.009 sec)

--------------
SHOW GRANTS FOR 'ddv_alterer'@'%'
--------------

+-----------------------------------------+
| Grants for ddv_alterer@%                |
+-----------------------------------------+
| GRANT USAGE ON *.* TO `ddv_alterer`@`%` |
+-----------------------------------------+
1 row in set (0.011 sec)

--------------
DROP SCHEMA ddv_probe4
--------------

Query OK, 2 rows affected (0.530 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
DROP MASKING POLICY IF EXISTS probe4_mask_phone
--------------

Query OK, 0 rows affected (0.062 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.005 sec)

--------------
DROP MASKING POLICY IF EXISTS probe4_mask_email
--------------

Query OK, 0 rows affected (0.076 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.007 sec)

--------------
DROP MASKING POLICY IF EXISTS probe4_mask_phone2
--------------

Query OK, 0 rows affected (0.062 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
DROP USER 'ddv_alterer'@'%'
--------------

Query OK, 0 rows affected (0.066 sec)

--------------
SHOW WARNINGS
--------------

Empty set (0.006 sec)

--------------
SELECT policy_name FROM mysql.column_masking_policies WHERE policy_name LIKE 'probe4%'
--------------

Empty set (0.009 sec)

--------------
SELECT user FROM mysql.user WHERE user IN ('ddv_alterer','ddv_pwtest')
--------------

Empty set (0.012 sec)

--------------
SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'ddv%'
--------------

+-------------+
| SCHEMA_NAME |
+-------------+
| ddv_mask    |
| ddv_support |
+-------------+
2 rows in set (0.025 sec)

--------------
SHOW GRANTS FOR 'ddv_agent'@'%'
--------------

+--------------------------------------------------------------------+
| Grants for ddv_agent@%                                             |
+--------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_agent`@`%`                              |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_agent`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_agent`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_agent`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_agent`@`%` |
| GRANT `r_support_agent`@`%` TO `ddv_agent`@`%`                     |
+--------------------------------------------------------------------+
6 rows in set (0.008 sec)

--------------
SHOW GRANTS FOR 'ddv_billing'@'%'
--------------

+----------------------------------------------------------------------+
| Grants for ddv_billing@%                                             |
+----------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ddv_billing`@`%`                              |
| GRANT SELECT ON `ddv_support`.`customers` TO `ddv_billing`@`%`       |
| GRANT SELECT ON `ddv_support`.`orders` TO `ddv_billing`@`%`          |
| GRANT SELECT ON `ddv_support`.`payments` TO `ddv_billing`@`%`        |
| GRANT SELECT ON `ddv_support`.`support_tickets` TO `ddv_billing`@`%` |
| GRANT `r_billing_admin`@`%` TO `ddv_billing`@`%`                     |
+----------------------------------------------------------------------+
6 rows in set (0.023 sec)

Bye
````

### evidence/84-compare.txt
````text
Compare-Object evidence\80-baseline.txt evidence\84-after.txt, with (n.nnn sec) timings stripped; differences listed below (nothing listed = identical).

InputObject                                           SideIndicator
-----------                                           -------------
| 375 | root            | localhost:62091 | Query   | =>           
| 231 | root            | localhost:53514 | Query   | <=
````

## Not captured

- The statement that created `ddv_alterer` (contains a password; ran with the echo off).
- Raw Audit JSON and the omitted event fields (timestamps, ids, IP, OS user, connection attributes).
- Contents of the audit log file in the Data folder (not accessed).
- Firewall DETECTING messages in the error log: none were returned at `log_error_verbosity` 2; the verbosity was not changed.
- mysql client exit codes (all 0 because of `--force`).

## Observations (Claude Code's reading, not evidence)

- Part A: with ALTER, INSERT, UPDATE and SELECT only, `ALTER TABLE ... MODIFY COLUMN phone VARCHAR(20)` succeeded, SHOW CREATE TABLE then showed no MASKING POLICY on `phone`, and SELECT returned real phone values. The same account re-attached the policy with the clause (no MANAGE_DATA_MASKING_POLICY), and a copy column filled from the masked `phone` held masked text. `CHANGE COLUMN phone phone2` without the clause also left real values and no policy.
- Part B: for ddv_agent, COUNT(DISTINCT email) and COUNT(DISTINCT phone) were 2 and 2 against 3 and 3 for ddv_billing; GROUP BY, the IN subquery, MIN/MAX, UNION, ORDER BY in a CTE, ROW_NUMBER, REGEXP, BETWEEN, HEX and equality ran on masked values for the agent. Details are in the 81 files.
- Part C: the three find_customer values and the literal-embedded text were accepted for ddv_agent (`OR` text outside a literal was denied with ERROR 6444); ddv_billing (not enlisted) read all six rows unmasked; ddv_norole was denied the find_customer shape and ddv_agent the COUNT(*) shape recorded for fw_norole. Each client run also had its own `select @@version_comment limit 1` counted.
- DETECTING: the five out-of-workflow selects ran and returned rows; `firewall_access_suspicious` rose from 0 to 10 and `firewall_access_denied` stayed 12.
- Part D: the Audit log for the run has 36 events, equal to `audit_log.events_written`. ddv_norole (no filter) has no events. The three password statements appear with `<secret>` in place of the password; the `SELECT` with a sentinel in a literal shows the sentinel.
