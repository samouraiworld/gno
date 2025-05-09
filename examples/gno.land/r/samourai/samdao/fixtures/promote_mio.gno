package main

import (
	"std"

	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	samdao.DAO.Propose(daokit.ProposalRequest{
		Title:       "Promote Mio to Confirmed Freelance",
		Description: "I think Mio is a great freelancer and he has been a great asset to the Samourai Coop.\n\n I think he should be promoted to a confirmed freelance.",
		Message: basedao.NewAssignRoleMsg(
			&basedao.MsgAssignRole{
				Address: std.Address("g1q2napmnjsjemxc97xntsfnvwrz7kdw4uavqkgg"),
				Role:    "Freelance",
			},
		),
	})
}
