package main

import (
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	daokit.InstantExecute(samdao.DAO, daokit.ProposalRequest{
		Title:       "Create a new blog post about the Samourai Coop",
		Description: "This post will be used to explain what the Samourai Coop is and how it works.",
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
