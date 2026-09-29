Task.delete_all

Task.create!(title: "Commander le gel", due_on: Date.yesterday, priority: 2)
Task.create!(title: "Préparer la cabine 2", due_on: Date.today)
Task.create!(title: "Rappeler Mme Diallo", due_on: Date.today + 3, done: true)
Task.create!(title: "Préparer les postes de coiffure", due_on: Date.yesterday, priority: 1, done: true)
Task.create!(title: "Désinfecter les outils", due_on: Date.today, priority: 0)
Task.create!(title: "Confirmer les rendez-vous du jour", due_on: Date.today, priority: 1)
Task.create!(title: "Réapprovisionner les shampoings", due_on: Date.yesterday, priority: 0, done: true)
Task.create!(title: "Commander les colorations", due_on: Date.today + 2, priority: 0, done: true)
Task.create!(title: "Nettoyer les bacs à shampooing", due_on: Date.today + 1, priority: 2)
Task.create!(title: "Rappeler les clientes pour leur suivi", due_on: Date.today + 2, priority: 1, done: true)
