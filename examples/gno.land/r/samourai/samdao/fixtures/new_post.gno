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
			"why-are-we-called-samourai-coop",
			"Why are we called Samouraï Coop?",
			`

![image](https://media.licdn.com/dms/image/v2/D4E22AQECLjTrb7KXwg/feedshare-shrink_800/B4EZaqHQT0GQAg-/0/1746610751621?e=1750291200&v=beta&t=Hy_DVE-0Gmwv3z8kegIlSH7i8mTDHCPm0UEO0Njd1ZI)

1. It's a real war to do *business* in this world without denying your values — to establish rules of honor, ethics, loyalty, discipline, and a philosophy that you defend no matter the storms.

2. We're French, and in **Samouraï**, there's **“Amour”**.

3. Because Samouraï and Japanese culture, and its values, embody **respect**. Power, mastery of the arts, expertise, humility, respect for others, quiet strength.

4. Because we designed this company to give us a lifetime of **freedom**, **intellectual stimulation**, **challenges** and **fun** doing what we love — and graphically, visually, the aesthetic offered us a great deal of **artistic freedom**, while embodying a **solid foundation** and a **notion of tradition** that would later overtake us.

4. Because **Shurik'n** (French rapper) gave me something to think about, and the energy to move forward from middle school onwards.  
👉 [https://lnkd.in/eQwS6CPM](https://lnkd.in/eQwS6CPM)

5. Because, tbh, saying **"we're Samouraï crew"** for 8 years is fun and still a source of pride — and we're not about to be ashamed of it.

---

🎉 We'll be celebrating our **8th birthday** in 2 months.  
Yes, it goes by fast.  
We're still **self-funded**, **async-first**, **fully remote**, operating **worldwide**, with **90% of our activity open source** (client works or our own projects), made for the **commons**.

---

Yes, we're both:
- punks  
- ninjas  
- hip-hop  
- filmmakers  
- developers  
- artists  
- hackers  
- protocol engineers  
- handicapped or maladjusted from the world around us  
- rebels  
- architects  
- designers  
- dancers  
- juniors and seniors  
- buidlers and breakers  
- academic profiles  
- maths nerds  
- rude boys and girls  
- vfx & post-prod artists  

...and lots of other stuff.  
**And we are one.**

---

No manager, no agile shits, no *sales team* — just **crews cooperating**, **delivering**, **autonomously**, with **experience**, **calm**, **discipline**.  
Always up for **unexpected or unusual adventures**, **challenges**, **research & development**, **products**, **content**, **experiences**.

We do it **our way**, with the **sharpness of katanas honed by passion**, and **heated by the love of work** that makes sense for us.

---

We're:
- « Samurai Cops »
- « Samurai Corp »
- « Sam crew »
- « Sam »
- even « ninjas »

You name it.

Whatever.  
You can count on us, behind the scenes, to keep on **learning**, **hacking**, **building**, with **humility inside**, whether it’s for:
- our own projects  
- agency mode  
- simple contributors  
- or external task force mode.

---

If you're a **friend**, **partner**, **customer**, **follower**, **subscriber**, **VC**, **investor we said no to and who never recovered**, **candidate to join us**, or just **curious** to see what it's like to bring all our skills together for a birthday party — we've got a **surprise planned in Paris**.  

You’re invited.  
Not for a big public event.  
Not something B2B or corporate.  
Just a pure **Samouraï spirit** thing to gather humans around an **IRL experience**.

📅 **Save the date: HyperHacktive Festival – July 3, in Paris.**  
💌 Comment to receive a private link invitation, or use your usual private partner channel with us.

---

Thanks for reading this, even if there’s no AI inside.  
**Cheers. 🥷**
`,
			"2021-01-01T00:00:00Z",
			[]string{"Fanny"},
			[]string{"Samourai Coop"},
		),
	})
}
