# Maze Solver

Limbaj: Verilog
Am implementat un automat pe 8 stari:
	`initialize: se initializeaza variabilele row si col cu cele initiale si se marcheaza campul cu 2. Trece in starea `direction.

	`direction: se retin coordonatele actuale in variabile auxiliare si in functie de directie se face deplasarea pe campurile adicacente. Se activeaza semnalul maze_oe si se trece in starea `direction + 1.

	`direction + 1: in cazul in care campul reprezinta un zid se alege o alta directie si se revine la coordonatele initiale si la starea `direction. Altfel, se marcheaza campul si se trece in stare `check_right.

	`check_right: se retin coordonatele actuale in variabile auxiliare. In functie de directia actuala se face deplasarea pe campul din dreapta si se trece in starea `check_right + 1.

	`check_right + 1: in cazul in care campul reprezinta un zid se revine la coordonatele precedente si se trece in starea `check_forward. Altfel, se modifica directia corespunzator deplasarii la dreapta, se marcheaza campul si se trece in starea `final_check.

	`check_forward: se retin coordonatele actuale in variabile auxiliare si se face deplasarea inainte corespunzator directiei. Se trece in starea `check_forward + 1.

	`check_forward + 1: in cazul in care campul reprezinta un zid se revine la coordonatele initiale si se modifica directia cu 90 de grade in sens trigonometric. Altfel, se marcheaza campul. Indiferent de situatie se trece in starea `final_check.

	`final_check: se verifica daca vreuna din coordonate reprezinta extremitati ale labirintului pentru a se modifica variabila done. In caz contrar se trece in starea `check_right pentru continuarea verificarii.
