#import "@preview/vocabulo:0.1.0": *

#let words = csv("example.csv")
#show: vocabulo(words, "English", "Deutsch")
