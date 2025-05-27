#!/bin/bash

set -e

GNO_ARGS="-gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657"
GNO_EXEC_ARGS="-gas-fee 2000000ugnot -gas-wanted 15000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657"

echo "====== [3] Proposing Role Promotion: Promote Mio (by Mathias) ======"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 Mathias promote_mio.gno

echo "====== [2] Instant Execute: New Blog Post by Fanny ======"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 fanny new_post.gno

echo "====== [2.1] Instant Execute: New Blog Post by Fanny ======"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 fanny new_post_roadmap.gno

echo "====== [4] Instant Execute: New Zenao Tech Project by Zooma ======"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 zooma new_zenao_project.gno

echo "====== [1] Proposing and Voting for Mikael Payroll ======"

echo "Step 1: Proposing with zooma"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 zooma new_payroll.gno

echo "Step 2: Voting YES with zooma"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 zooma vote_yes.gno

echo "Step 3: Voting YES with fanny"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 fanny vote_yes.gno

echo "Step 4: Voting YES with yohann"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 yohann vote_yes.gno

echo "Step 5: Voting YES with yang (accountability)"
gnokey maketx run -gas-fee 10000000ugnot -gas-wanted 95000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 Yang vote_yes.gno

echo "Step 6: Executing proposal with Mikael"
gnokey maketx call -pkgpath "gno.land/r/samourai/samdao" -func "Execute" -args "5" -gas-fee 2000000ugnot -gas-wanted 15000000 -broadcast -chainid dev -remote tcp://127.0.0.1:26657 Mikael
