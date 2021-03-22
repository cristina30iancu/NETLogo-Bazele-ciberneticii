globals [ gaze_emanate ] ;variabila globala pentru a afisa gazele emanate

breed [ masini car ]  ;agentii tip masina
breed [camioane truck] ;agentii tip camion
breed [ poluare cloud ] ;agentul nor, poluarea
breed[something somethings] ;agentii decor: casa, copaci,etc

to set-env ;procedura care se executa cand apasam "Setup"
  clear-all ;curatam cadrul
  set-default-shape masini "car"   ;setare agenti
  set-default-shape camioane "truck"
  set-default-shape poluare "cloud"
  set-background
  set-turtles
  setup-peisaj
  setup-soare
  reset-ticks
end


to go ;procedura care se executa cand apasam "Crestere poluare"
  if count turtles with [shape = "cloud"] = 960 [user-message (word
      "Orasul este suprapoluat. Simularea s-a oprit.")stop] ;conditia de oprire si mesajul afisat
  move-turtles1
  gain-gaze_emanate
  tick
end

to go2 ;procedura care se executa cand apasam "Crestere si scadere poluare"
   if count turtles with [shape = "cloud"] = 960 [user-message (word
      "Orasul este suprapoluat. Simularea s-a oprit.")stop] ;conditia de oprire si mesajul afisat
  move-turtles2
  gain-gaze_emanate
  tick
end


; procedura recursiva esentiala pentru ca atunci cand apasam "Initializare", sa nu apara doua autoturisme in acelasi loc
to separate-cars
  if any? other turtles-here [
    fd 1
    separate-cars
  ]
end

to set-turtles ;procedura de setare a agentilor
  create-turtles Nr_masini [
  set xcor random-pxcor  ;pozitionare aleatoare pe axa ox
  set ycor -16  ;pozitionare axa oy
  set heading 90 ;directia spre dreapta
  set shape "car" ;forma
  ]
  create-turtles Nr_camioane [
  set xcor random-pxcor
  set ycor -12
  set heading 90
  set shape "truck"
  ]

  create-turtles Poluare1 [
  setxy random-xcor random-ycor
  set color grey
    set size 1.5
  set shape "cloud"
  ]

end

to set-background  ;setarea cadrului, culori, strada
  ask patches [
   set pcolor 88
  if (pycor < -6) and (pycor > -12) [ set pcolor 68 ]
  if (pycor < -10) and (pycor > -18) [ set pcolor 8 - random-float 0.4 ]
  ]
  draw-a-line -16.5 white 0
  draw-a-line -15.5 white 0.5
  draw-a-line -13.5 white 0
  draw-a-line -14 white 0
  draw-a-line -12.5 white 0.5
  draw-a-line -11 white 0
end

to draw-a-line [ y line-color gap ] ;desenarea liniilor strazii
  create-turtles 1 [
    setxy random-xcor y
    hide-turtle
    set color line-color
    set heading 90
    repeat world-width [
      pen-up
      forward gap
      pen-down
      forward (1 - gap)
    ]
    die
  ]
end

to setup-peisaj ;setarea peisajului deasupra strazii
 ask patches with [pcolor = 68] [
    if count neighbors with [pcolor = 68] = 8 and not any? turtles in-radius 2[
         sprout-something 1
      [
          set shape one-of ["tree" "house" "flower" "house colonial" "plant" "house bungalow"]
          if shape = "tree" [set color green]
          ifelse shape = "flower" [ set size 1] [set size 2]
          stamp
        ]
  ]]
 ask something [die]
end

to setup-soare ;setarea soarelui
  set-default-shape turtles "sun"
  create-turtles 1
  [
   set color yellow
   set xcor 13
   set ycor 13
   set size 5
   stamp
 if shape = "sun" [die]
  ]
end

to move-turtles1 ;procedura de miscare a masinilor, prima varianta
  ask turtles [
  fd 1
  separate-cars
   ]
  pollute-more
end

to move-turtles2 ;procedura de miscare a masinilor, a doua varianta
  ask turtles [
  fd 1
  separate-cars
   ]
  pollute-less
end


to pollute-more   ;aceasta procedura face ca dupa un timp fiecare miscare a masinii sa mai produca un nor de poluare
 create-turtles 1 [ ;aceasta procedura face ca dupa un timp fiecare miscare a masinii sa mai produca un nor de poluare
    set color grey
    set size 1.5
   set shape "cloud"
    setxy random-xcor random ycor
    lt 45 fd 1 ]
  ask turtles with [shape = "car"] [set gaze_emanate (gaze_emanate + 0.5) ] ;cu cat se misca mai mult, cu atat polueaza mai mult
  ask turtles with [shape = "truck"] [set gaze_emanate (gaze_emanate + 0.5) ]
end


to pollute-less   ;aceasta procedura face ca, dupa un timp, fiecare miscare a masinii sa mai scada un nor de poluare
 create-turtles 1 [
    set color grey
    set size 1.5
   set shape "cloud"
    setxy random-xcor random ycor
    lt 45 fd 1 ]
  ask turtles with [shape = "car"] [set gaze_emanate (gaze_emanate + 0.5) ] ;cu cat se misca mai mult, cu atat polueaza mai mult
  ask turtles with [shape = "truck"] [set gaze_emanate (gaze_emanate + 0.5) ]
    if ticks > 400  [  ;conditie ca la un numar de tick-uri, sa inceapa sa scada poluarea
        ask turtles with [shape = "cloud"]  [ kill ]  ;apelez procedura de scadere a poluarii
    ask turtles with [shape = "car"] [set gaze_emanate (gaze_emanate - 2.5) ] ; scad gazele emanate la acest moment
  ask turtles with [shape = "truck"] [set gaze_emanate (gaze_emanate - 2.5) ]
        reset-ticks ;resetarea tick-urilor
         tick  ]
end

to kill ;procedura care diminueaza poluarea
   ask one-of turtles with [shape = "cloud"] [ die ]
end

to gain-gaze_emanate  ;procedura care afiseaza emisiile de gaze
  ask turtles with [shape = "car"] [
    set label gaze_emanate
    ifelse display-gaze_emanate?
    [set label gaze_emanate]
    [set label ""]
  ]
  ask turtles with [shape = "truck"]
  [
    set label gaze_emanate
    ifelse display-gaze_emanate?
    [set label gaze_emanate]
    [set label ""]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
12
680
483
-1
-1
14.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
60
15
148
48
Initializare
Set-env
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
10
338
126
383
Cate automobile?
count turtles with [shape = \"car\"]
17
1
11

SLIDER
15
192
187
225
Nr_masini
Nr_masini
1
32
13.0
1
1
NIL
HORIZONTAL

BUTTON
40
55
160
88
Creste poluarea
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
10
403
134
448
Grad Poluare
count turtles with [shape = \"cloud\"]
17
1
11

PLOT
710
32
1176
363
Situatia poluarii
time
populatie
0.0
200.0
0.0
200.0
true
true
"" ""
PENS
"poluare" 1.0 0 -7500403 true "" "plot count turtles with [shape = \"cloud\"] "
"gaz" 1.0 0 -2674135 true "" "plot (gaze_emanate) "

SWITCH
9
293
195
326
display-gaze_emanate?
display-gaze_emanate?
0
1
-1000

SLIDER
15
150
187
183
Poluare1
Poluare1
0
500
157.0
1
1
NIL
HORIZONTAL

SLIDER
14
239
186
272
Nr_camioane
Nr_camioane
0
32
14.0
1
1
NIL
HORIZONTAL

BUTTON
17
99
184
132
Creste si scade poluarea
go2
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## CE ESTE?

Modelul nostru urmareste evolutia poluarii unui oras, pe baza circulatiei rutiere. Simularea evidentiaza consecintele devastatoare ale utilizarii in exces a autoturismelor ca metoda de transport, fapt ce duce la cresterea accelerata a poluarii, in cea de-a doua varianta fiind posibila si o usoara scadere a acesteia, insa ajungand la acelasi final: suprapopularea orasului.

## CUM FUNCTIONEAZA?

Cadrul prezinta o sosea cu mai multe benzi, dintre care doua sunt circulate de masini personale si camioane, o zona verde de decor, cu flori, copaci si case, iar pe cerul senin si inca nepoluat straluceste un soare arzator.  Cu fiecare miscare a autoturismelor prezente pe carosabil, mai apare cate un norisor de poluare ce impovareaza atmosfera si se “plimba” nestingherit, totodata crescand cantitatea de gaze de esapament emanata in aer. Simularea se opreste atunci cand numarul maxim de 960 norisori este atins, orasul devenind suprapoluat. Varianta a doua aduce mici modificari: dupa 400 miscari, atat poluarea cat si gazele emise scad, insa apoi continua sa creasca, fapt ce ilustreaza faptul ca este nevoie de o schimbare semnificativa in circulatia rutiera pentru a combate poluarea.

## CUM SE UTILIZEAZA?

In zona de interfata poate fi setat numarul de agenti prezenti in simulare: masini, camioane, norisorii de poluare. Un monitor afiseaza gradul de poluare (numarul agentilor norisori), dar si numarul total al autoturismelor de pe carosabil. Aici se mai afla si un plot, ce urmareste evolutia in timp a gradului de poluare si a gazelor de esapament emanate. 
Apasand butonul Initializare, tot acest cadru se initializeaza, iar butonul Creste poluarea declanseaza circulatia rutiera si implicit poluarea atmosferei. Butonul Creste si scade poluarea declanseaza cea de-a doua varianta a simularii.

## DE OBSERVAT!

Puteti observa, cu ajutorul butoanelor incluse, evolutia numarului de agenti ai poluarii
si gazelor de esapament emanate.

## DE INCERCAT!

Jucati-va cu sliderele prezente: afisarea gazelor de esapament emise, modificarea numarului de masini sau camioane, dar si una din cele doua variante: crestere sau crestere+scadere a poluarii. 

## EXTINDEREA MODELULUI

Adaugarea de noi conditii pentru crestere si/sau scadere a poluarii: modificare numar autoturisme, influenta circulatiei asupra poluarii, etc.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

bus
false
0
Polygon -7500403 true true 15 206 15 150 15 120 30 105 270 105 285 120 285 135 285 206 270 210 30 210
Rectangle -16777216 true false 36 126 231 159
Line -7500403 false 60 135 60 165
Line -7500403 false 60 120 60 165
Line -7500403 false 90 120 90 165
Line -7500403 false 120 120 120 165
Line -7500403 false 150 120 150 165
Line -7500403 false 180 120 180 165
Line -7500403 false 210 120 210 165
Line -7500403 false 240 135 240 165
Rectangle -16777216 true false 15 174 285 182
Circle -16777216 true false 48 187 42
Rectangle -16777216 true false 240 127 276 205
Circle -16777216 true false 195 187 42
Line -7500403 false 257 120 257 207

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car side
false
0
Polygon -7500403 true true 19 147 11 125 16 105 63 105 99 79 155 79 180 105 243 111 266 129 253 149
Circle -16777216 true false 43 123 42
Circle -16777216 true false 194 124 42
Polygon -16777216 true false 101 87 73 108 171 108 151 87
Line -8630108 false 121 82 120 108
Polygon -1 true false 242 121 248 128 266 129 247 115
Rectangle -16777216 true false 12 131 28 143

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cloud
false
0
Circle -7500403 true true 13 118 94
Circle -7500403 true true 86 101 127
Circle -7500403 true true 51 51 108
Circle -7500403 true true 118 43 95
Circle -7500403 true true 158 68 134

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
false
0
Circle -7500403 true true 75 75 150
Polygon -7500403 true true 300 150 240 120 240 180
Polygon -7500403 true true 150 0 120 60 180 60
Polygon -7500403 true true 150 300 120 240 180 240
Polygon -7500403 true true 0 150 60 120 60 180
Polygon -7500403 true true 60 195 105 240 45 255
Polygon -7500403 true true 60 105 105 60 45 45
Polygon -7500403 true true 195 60 240 105 255 45
Polygon -7500403 true true 240 195 195 240 255 255

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
