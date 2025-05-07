package main

import (
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	daokit.InstantExecute(samdao.DAO, daokit.ProposalRequest{
		Title: "What is Samourai Coop?",
		Message: samdao.NewNewPostMsg(
			"what-is-samourai-coop",
			"What is Samourai Coop?",
			"Samourai Coop is a cooperative of freelancers and employees who are passionate about creating a better world.",
			"2021-01-01T00:00:00Z",
			[]string{"Fanny"},
			[]string{"Samourai Coop"},
		),
	})
}
