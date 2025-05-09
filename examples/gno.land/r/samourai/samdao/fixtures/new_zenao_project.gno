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
		Title:       "Create a new web3 ticketing platform based on Gno: Zenao",
		Description: "We wanted to create a project to allow people to organize events and sell tickets for them where each events in itself is a DAO.",
		Message: samdao.NewNewTechProjectMsg(
			"Zenao.io",
			"Zenao allows you to create your own event DAO and sell tickets for it. You can interact with your participants, launch polls, and govern your event by defining the rules.",
			[]project_manager.Task{
				{
					Name:        "HyperHacktive target",
					Description: "Zenao plateform should met the requirements for the HyperHacktive organized by the Samourai Coop.\nSee more at [HyperHacktive](https://www.samourai.world/hyperhacktive)",
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
