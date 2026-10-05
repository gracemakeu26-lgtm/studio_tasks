# Journal de test medu-tameri

## Séance 1 — <28-09-2026>

Jour 3 : Fiche de rôle 

| Rôle           | Problème principal                          | Réponse MEDU/Tameri                  | Workflow principal                                 |
| -------------- | ------------------------------------------- | ------------------------------------ | -------------------------------------------------- |
| **Étudiant**   | S'inscrire et présenter son projet d'études | Portail MEDU en 5 étapes             | Inscription → projet → accompagnement → accès MEDU |
| **Conseiller** | Suivre les étudiants qui lui sont confiés   | CRM avec accès à ses leads           | Lead assigné → contact → suivi → progression       |
| **Manager**    | Distribuer et superviser les leads          | Pipeline + assignation/réassignation | Nouveau lead → assignation → suivi                 |
| **Admin**      | Administrer l'ensemble du système           | Accès complet aux leads et données   | Gestion → modification → montant → conclusion      |
| **AYAGO**      | Suivre les étudiants envoyés à MEDU         | CRM en lecture seule sur ses leads   | Envoi étudiant → création lead → consultation      |

## Séance 2 — <29-09-2026> — rôle : <Etudiant>

### Nominal (ce qui doit marcher)
- Inscription de l'etudiant 1 id : MEDU-AYG-000003 → que l'étudiant soit inscrit → Félicitation, votre inscription est terminée → OK
- Inscription de l'etudiant 2 id : MEDU-AYG-000004 → que l'étudiant soit inscrit → Félicitation, votre inscription est terminée → OK
- Inscription de l'etudiant 3 → que l'étudiant soit inscrit → Une erreur est survenu, inscription terminée → KO

## Séance 3 — <30-09-2026> — rôle : <Etudiant>

### Limites (valeurs extrêmes)
- un étudiant de 14 ans → Erreur de saisie → Vous devez avoir au moins 15 ans pour vous inscrire → OK
- une date de naissance dans le futur → Erreur de saisie → La date de naissance ne peut être dans le futur → OK
- un nom d'1 lettre → Erreur de saisie → Ce champ est trop court → OK
- un nom de 81 lettres → Erreur de saisie → Ce champ est trop long → OK
- Étant donné le domaine « Autre », quand je saisis 120 → aucune erreur → Possibilité de continuer → OK
- Étant donné le domaine « Autre », quand je saisis 121 → une erreur → Impossible de saisir le 121eme caractère → OK

### Négatif (ce qui doit être refusé)
- teste un champ vide → Erreur de saisie → Impossibilité d'avancer → OK
- un champ rempli d'espaces → Erreur de saisie → Ce champ est trop court → OK
- un email invalide → Erreur de saisie → Saisissez une adresse email valide → OK
- Étant donné l'écran des frais, quand je laisse une des 3 cases non cochée→ Impossibilité d'avancer → OK
- Quand je met un nom <b>Test</b> et je regarde le CRM, je vu que le texte s'affiche tel quel cela prouve que tous les noms sont accéptés

## Séance 4 — <30-10-2026> — rôle : <Conseiller / Manager>
        
| Adresse visitée | Action | Critique de la page pipline |
|---------|------|----------|
| https://tameri.staging.conop-services.com/leads   | index  | Cette page permet d'afficher les leads        |
| https://tameri.staging.conop-services.com/leads/assignments  |  assigné  | La tâche principale est d'assigner un lead        |
|https://tameri.staging.conop-services.com/leads/6abd3271b3239c97b95f5f78/edit | edit | tâche principale est de modifier un lead ce qui la sert ce sont les informations du lead ce qui le gène c'est que toutes les informations du lead ne sont pas présentes comme le numéro et whatsapp |

## Séance 5 — <02/10/2026> — rôle : <conseiller>

- Étant donné le compte conseiller, quand j'ouvre la liste des leads, alors je ne vois que ceux qui m'ont été assignés. OK
- Étant donné un de mes leads, quand je note un appel et que je le passe à « Contacté », alors le changement apparaît dans son historique. OK
- Étant donné un de mes leads, quand j'essaie de le passer à « 1ère lettre d'acceptation payée », j'y arrive sans problème. OK
- Étant donné un de mes leads, quand je le passe à « Abandon » sans motif je reçois un message qui me demande le motif donc le motif est exigé puis avec un motif, ça passe sans problème. OK
- Étant donné l'adresse d'un lead qui n'est pas à moi, puis l'adresse /leads/abc, quand je les ouvre, j'arrive sur la page https://tameri.staging.conop-services.com/home. Le conseiller ne peut deviner qu'un lead existe parce que il ne voit que ceux qui lui sont assignés et l'adresse dresse d'un lead est compliqué pour qu'il puissse le déviner.
- Étant donné la fiche d'un lead, quand je cherche le numéro WhatsApp à rappeler, 2 clics sont nécessaires.

## Séance 5 — <02/10/2026> — rôle : <admin/AYAGO>

- Étant donné le compte admin, quand je saisis un montant et une date d'encaissement puis que je passe un lead à « 1ère lettre d'acceptation payée », alors le lead change d'étape OK 
- Étant donné le montant de 150 USD par lettre dans le CRM et les 300 USD annoncés sur le portail, quand je les compare, alors c'est cohérent.
- Étant donné le compte AYAGO, quand j'ouvre la liste des leads, alors je ne vois que des leads venus d'AYAGO, sans partie financière. OK
- Étant donné le compte AYAGO, quand je tape l'adresse de modification d'un lead (/leads/<id>/edit), alors je vérifie que la modification est refusée. OK
- Étant donné le tableau de bord, quand je compare ses chiffres (inscrits, inscriptions terminées, accès MEDU, demandes d'accompagnement) j'ai créé 6 leads et dans le tableau de bord il y'en a 8 donc il y a écart de 2.