---
title: SGE
weight: 9
pre: "<b></b>"
---

`qconf -mrqs`
```bash
{
   name         peruser_limit
   description  "per user rule sets"
   enabled      TRUE
   limit        users {*} to slots=48
}
```
48 表示每个用户最多能用的CPU核数


