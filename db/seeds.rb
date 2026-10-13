Session.delete_all
Task.delete_all
User.delete_all

manager = User.create!(
  name: "Camille Laurent",
  email_address: "manager@studio-lumiere.fr",
  role: "manager",
  password: "password"
)

esthetician = User.create!(
  name: "Nora Benali",
  email_address: "esthetician@studio-lumiere.fr",
  role: "esthetician",
  password: "password"
)

receptionist = User.create!(
  name: "Lucas Moreau",
  email_address: "receptionist@studio-lumiere.fr",
  role: "receptionist",
  password: "password"
)

Task.create!(
  title: "Finaliser le planning de la semaine",
  description: "Répartir les rendez-vous et vérifier les disponibilités de l'équipe.",
  user: manager,
  due_on: Date.today + 2,
  priority: 2
)
Task.create!(
  title: "Réapprovisionner les produits de soin",
  description: "Vérifier le stock des masques et commander les références manquantes.",
  user: esthetician,
  due_on: Date.today + 1,
  priority: 2
)
Task.create!(
  title: "Confirmer les rendez-vous importants",
  description: "Appeler les clientes dont le rendez-vous nécessite une préparation particulière.",
  user: receptionist,
  due_on: Date.today,
  priority: 2
)
Task.create!(
  title: "Valider la facture du fournisseur",
  description: "Comparer la facture avec la dernière livraison avant la clôture hebdomadaire.",
  user: manager,
  due_on: Date.today - 2,
  priority: 1
)
Task.create!(
  title: "Rappeler la cliente pour déplacer son rendez-vous",
  description: "La demande de changement est restée sans réponse depuis hier.",
  due_on: Date.yesterday,
  priority: 1
)
Task.create!(
  title: "Ranger et désinfecter la cabine 2",
  description: "La cabine a été préparée après le dernier soin.",
  user: esthetician,
  due_on: Date.today - 1,
  priority: 0,
  done: true
)
Task.create!(
  title: "Préparer les fiches des nouvelles clientes",
  description: "Créer les dossiers avant les rendez-vous de la semaine prochaine.",
  due_on: Date.today + 3,
  priority: 1
)
Task.create!(
  title: "Nettoyer les appareils de soin",
  description: "Suivre le protocole d'entretien après chaque utilisation.",
  user: esthetician,
  due_on: Date.today,
  priority: 0
)
Task.create!(
  title: "Mettre à jour les horaires affichés",
  description: "Afficher les horaires exceptionnels du prochain jour férié.",
  user: receptionist,
  due_on: Date.today + 5,
  priority: 1
)
Task.create!(
  title: "Envoyer le récapitulatif de caisse",
  description: "Le total de la journée a été vérifié et transmis à la gérante.",
  user: receptionist,
  due_on: Date.today - 1,
  priority: 1,
  done: true
)
Task.create!(
  title: "Trier les échantillons et brochures",
  description: "Aucune échéance fixe, à faire pendant un créneau calme.",
  user: manager,
  priority: 0
)
Task.create!(
  title: "Préparer la commande de linge",
  description: "Estimer les besoins avant la prochaine livraison mensuelle.",
  due_on: Date.today + 7,
  priority: 0
)
