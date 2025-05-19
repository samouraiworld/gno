package main

import (
	"gno.land/p/samourai/daocond"
	"gno.land/r/samourai/samdao"
)

func main() {
	samdao.DAO.Vote(5, daocond.VoteYes)
}
