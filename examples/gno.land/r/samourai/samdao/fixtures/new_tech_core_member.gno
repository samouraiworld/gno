package main

import (
	"std"

	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
	"gno.land/r/samourai/samdao"
)

func main() {
	id := samdao.DAO.Propose(daokit.ProposalRequest{
		Title: "Promote Mio to Confirmed Freelance",
		Message: basedao.NewAssignRoleMsg(
			&basedao.MsgAssignRole{
				Address: std.Address("g1q2napmnjsjemxc97xntsfnvwrz7kdw4uavqkgg"),
				Role:    "Freelance",
			},
		),
	})
	std.Emit("event", "new_proposal", ufmt.Sprintf("%d", id))
	samdao.DAO.DummyFunc()
}
