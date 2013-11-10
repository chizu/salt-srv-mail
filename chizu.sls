chizu:
  user:
    - fullname: Nell Hardcastle
    - shell: /bin/bash
    - present
    - groups:
      - sudo

? AAAAB3NzaC1kc3MAAAEBAIreLGAFMrzcrIMDC9Dl7n9fV+TX86F+xARacgz8JZUVyRxngqrxy+gG6QLzQfnp4/9jR9V10JYD7Vbl46VKWOZbe/ob5Ep92kLSP/OtmcmOC9I+JKfapg5WLpPUNDMgQn/T2RHdS5hNvXvWv2JC415QRd402QPhzpCi7tt2bOT1o9PiZa8/JwuRd3PaKKS4bnnIEigcnE0GRpIe7xUjKvQzfVsgowKCKPmGs3CUqgGRgRYpIx3Ji4S2hamgwvcK1ufXCZ2KLZOFIQQFOLiLyCdP/hrk0EbE6/dNalV56s/g0P6ikZai0cExGh2BgzdNKhpdCgAIX4ZVc5k5mq5iALkAAAAVAN+iCfIzvvYelniRw/tIy4CiU0bhAAABAEumf/J6aE9MnsC5nLCanpi0/v2V7zjHn5mknCnu92iGRajdEeTR5ZnjVBza9axYADoL+7Vt1MWubKk9/p4dvUunmDI/BMgz7t6Js+Ejgxj4pDTZnd5rm5ehW1WF/YeF6389cpDEvQMxjet169fwiABFDSaCX56ExL4C2Sqe6NliuT8diP7fK50gRtDU3NUMhWf53fL4cHPcsNDkN2wLgDAu4hRIF7iblSuJeOCnm5zCaR++wUgUrSS2UC8m7bptVntn49wpTubbTfx2u1k3idkSgCG47wsgudnMi1kMukNqd2BLho76YchoGVrEbK4EXkomvDupKJ3lDENn3rUNWWUAAAEAdKyZCDYK58iGRvHe8HrAB17gkYz3zvBsatkk1gSBIWkVmBBANkXjEJNiEhEjJx+Fy3Ha27LNDUt76YYL8Mhvfsdppta60DbJBn0fV2E5DDdP1aKn+HBpdXuu4orCHmwlIP11GV3aMl2dOwh8ys+QyRGSG/sOBGDkfGgpHtg/3sIUwlRyf6LHcwXjQOFyBhhqlqRi/NB4Ik0wMo4+hRuyS63o/W/7Ntzl0V2zKT5tRtTHnrwRxUVnLdpgl07EdI3pkUuKU9vbZv6NU4/Hgvh7fdEMSkqhK5cnfCb/nw7HcQ1/CcJp7zdDTpGHMtUCSA2Ebtdv0YZKU6INMHtRBR2NQw==
:
  ssh_auth:
    - present
    - user: chizu
    - enc: ssh-dss
    - require:
      - user: chizu
