#import "@preview/vocabulo:0.1.0": *

#let filepath = sys.inputs.at("words", default: "words.csv")
#let words = csv(filepath)

#show: vocabulo(words, "English", "German")
