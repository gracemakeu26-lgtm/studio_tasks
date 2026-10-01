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

## Séance 4 — <30-10-2026> — rôle : <Etudiant>
        
| Adresse visitée | Action | Critique de la page pipline |
|---------|------|----------|
| https://tameri.staging.conop-services.com/leads   | index  | Cette page permet d'afficher les leads        |
| https://tameri.staging.conop-services.com/leads/assignments  |  assigné  | La tâche principale est d'assigner un lead        |
|https://tameri.staging.conop-services.com/leads/6abd3271b3239c97b95f5f78/edit | edit | tâche principale est de modifier un lead ce qui la sert ce sont les informations du lead ce qui le gène c'est que toutes les informations du lead ne sont pas présentes comme le numéro et whatsapp |

