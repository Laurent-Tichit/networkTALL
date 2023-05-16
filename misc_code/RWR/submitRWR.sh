#!/bin/bash

#SBATCH --nodes=1            # nombre de noeuds. Je n'ai jamais testé plus d'un noeud
#SBATCH --cpus-per-task=16   # nbre de coeurs demandés. Vérifier avec scontrol show node que le noeud a au moins autant de coeurs
#SBATCH --time=2:00          # durée au bout de laquelle votre job peut être tué. L'estimer au mieux car le scheduler fait passer les petits jobs en premier
#SBATCH --mem=64000			 # RAM demandée. vérifier avec scontrol show node que le noeud a au moins autant de coeurs
#SBATCH --partition skylake  # type de noeud demandé. sinfo permet d'obtenir la liste
#SBATCH --account=a346		 # mon compte au mésocentre

./RWR.py					 # mon super programme de calcul à moi ! (chmod +X ,  +shebang (#!/usr/bin/env python3))

