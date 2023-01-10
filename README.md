#epuck_robots
# Projet IAR : Segregation in Swarms of e-puck Robots Based on the Brazil Nut Effect

- Lyna SAOUCHA, Karl CLEUZIOU
- M2 Androide : Intelligence Artificielle pour la Robotique
- 2022/2023

## Objectifs

Dans le cadre de notre projet de robotique, nous avons pour objectif de lire et résumer un article scientifique et de réaliser un travail de ré-implémentation. Nous avons travaillé sur **la ségrégation de robots epucks en suivant l'effet *noix de Brésil*** basé sur l'article de Jianing Chen, Melvin Gauci, Michael J. Price et Roderich Groß [[1]](https://www.ifaamas.org/Proceedings/aamas2012/papers/4A_4.pdf)

Le phénomène des noix du Brésil est un phénomène qui survient lorsque des noix sont mélangées avec des noix classiques plus petites et légères. On observe que **lorsque l’on secoue toutes les noix ensemble, les noix du Brésil remontent à la surface**, créant une ségrégation avec les noix classiques qui vont en dessous. Notre but est d'implémenter cet effet avec une **simulation de 20 robots e-pucks**, de tailles différentes pour représenter les différentes tailles de noix. [Voir le résumé de l'article](https://github.com/yashii19/epuck_robots/blob/main/resume_article.pdf)

Les résultats ont été quantifiés à l’aide d’un indicateur nommé *erreur de ségrégation*, sur lequel nous avons basé nos observations, en reproduisant les tests donnés dans l'article.


## Implémentation

Pour réaliser le projet, nous avons décidé d'utiliser **l'environnement de MATLAB**. Nous nous sommes basés sur un code présenté par la Fouloscopie qui servait à organiser un tournoi collectif de robotique sur sa chaîne Youtube [[2]](https://www.youtube.com/watch?v=5CaVhGTG8eA&ab_channel=Fouloscopie). Dans une arène, des robots doivent trouver une cible et la neutraliser le plus vite possible. Le tournoi consiste à coder une stratégie qui permet aux robots d'avoir le comportement le plus efficace possible. 

Dans un premier temps, nous avons repris le code de création des robots pour pouvoir les diviser en **plusieurs catégories selon leurs tailles et leur attribuer  des paramètres en fonction**. En effet, les robots ont tous la même taille dans la simulation donc il faut ajouter une taille virtuelle, une zone autour du robot dans laquel aucun objet ne peut entrer.

L'article explique que le déplacement des robots se fait selon une **combinaison de trois vecteurs** : un vecteur gravitationnel, un vecteur aléatoire et un vecteur de répulsion. Dans un second temps, nous avons désactivé tout ce qui concerne la neutralisation de la cible et l'avons remplacé par la source gravitationnelle vers laquelle les robots sont attirés. Nous avons modifié le déplacement des robots pour correspondre le mieux possible à l'article et avons codé la répulsion selon la taille virtuelle des robots.

Enfin, nous avons **implémenté l'erreur de ségrégation** et l'affichons en temps réel pendant la simulation. 

> > **Pour lancer le code : lancer le *main.m* sur MATLAB.**
> > Code de configuration des robots : *robots.m*
> > Algorithme de mise à jour : *update.m*

## Observations

Pour la partie expérimentale, nous allons reprendre les paramètres testés de l'article. Nous allons d'abord **tester si la différence de taille a une influence sur l'erreur de ségrégation**. Nous mesurons la moyenne du temps en seconde que prends l'erreur de ségrégation (SE) à être nulle sur 10 essais, respectivement pour des tailles similaires, multipliées par 2, par 3, par 4 et par 5.


| Taille | Temps  |
| ------ | ------ |
| x1     |  ∞     | 
| x2     | 16,5   | 
| x3     |  16,1     |
| x4     | 15,5   |
| x5     |  15,1     |

On observe que **l'erreur de ségrégation n'atteint jamais ou rarement 0 lorsque les robots sont tous de la même taille et est finie lorsqu'ils sont de tailles différentes**. On observe aussi que lorsque la différence de taille augmente, le temps que met SE à être nulle est de plus en plus faible. On peut en conclure que **la variation de taille a bien une influence sur l'erreur de ségrégation**.

Nous allons ensuite tester **l'influence de la différence de taille sur la distribution spatiale**. Pour cela, on mesure la moyenne de la distribution spatiale pour les robots de taille *small* puis les robots de tailles *big* sur 5 essais, respectivement pour des tailles similaires, multipliées par 2, par 3, par 4 et par 5.

| Taille | Distribution Spatiale Small  | Distribution Spatiale Big |
| ------ | ------ |----- |
| x1     |   0.42 | 0.47 |
| x2     | 0.32   | 0.73 |
| x3     | 0.32   | 0.77 |
| x4     |  0.31  | 0.71 |
| x5     |   0.32 | 0.79 |


On observe que lorsque les robots sont de tailles égales, la distribution spatiale des deux groupes est très proche voir similaire. En revanche, **lorsque les robots sont de tailles différentes, l'écart est plus grand** (environ 0.40) avec une valeur faible pour les petits robots. On en conclut que lorsque les robots sont de tailles différentes, les gros robots ont tendance à plus aller vers l'extérieur et les petits robots à se rapprocher, **ce qui confirme l'effet Noix de Brésil** qu'on essaye de modéliser.

## Conclusion

L'effet noix du Brésil est un effet de convection granulaire observable dans la nature. Dans l'article étudié, les chercheurs testent cet effet sur des robots epucks. Dans notre cas, nous avons modélisé une simulation de cet effet en utilisant MATLAB en suivant le protocole expérimental de l'article. 

Nous avons pu observer que la différence de taille a une influence sur les métriques choisies, à savoir l'erreur de ségrégation et la distribution spatiale. Nos résulats sont assez correspondants avec ceux présentés pour la ségrégation mais pas pour la distribution spatiale : les disparités entre les valeurs dans l'article sont beaucoup plus importantes que les notres. De plus, certaines expériences de l'article avaient des resultats incohérents dû à des problèmes techniques, contrainte inexistante dans notre version.

Nous pouvons poursuivre ce travail en essayant cette fois d'appliquer notre code à des vrais robots epucks afin de tester cette simulation en condition réelle et de créer une réelle ré-implémentation de l'expérience de l'article.
