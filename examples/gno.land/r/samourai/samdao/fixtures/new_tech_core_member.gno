package main

import (
	"std"

	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	samdao.DAO.Propose(daokit.ProposalRequest{
		Title: "Promote Mio to Confirmed Freelance",
		Message: basedao.NewAssignRoleMsg(
			&basedao.MsgAssignRole{
				Address: std.Address("g1q2napmnjsjemxc97xntsfnvwrz7kdw4uavqkgg"),
				Role:    "Freelance",
			},
		),
	})
}
