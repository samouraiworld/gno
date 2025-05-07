package main

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/samourai/daokit"
	"gno.land/p/samourai/project_manager"
	"gno.land/r/samourai/samdao"
)

func main() {
	daokit.InstantExecute(samdao.DAO, daokit.ProposalRequest{
		Title: "New Zenao Project",
		Message: samdao.NewNewTechProjectMsg(
			"Zenao",
			"Zenao is a project that will help us to create a better world.",
			[]project_manager.Task{
				{
					Name:        "Hyperktive target",
					Description: "Goal is met the requirements for the hyperktive event",
					Members:     avl.NewTree(),
					Status:      project_manager.StatusDoing,
				},
			},
			[]std.Address{
				std.Address("g1q2napmnjsjemxc97xntsfnvwrz7kdw4uavqkgg"),
				std.Address("g1tqys7x6qmrlx9ed0ja7kj6fmuqa828h58xpj8s"),
				std.Address("g12vcdv85v76zt7g30nhypflz0mah5m2k0xculfu"),
			},
		),
	})
}
