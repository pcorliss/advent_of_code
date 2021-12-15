package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
`)

func TestIngestStartString(t *testing.T) {
	start, _ := StringToInstructions(inputStr)
	assert.Equal(t, "NNCB", start, "they should be equal")
}

func TestIngestInstructions(t *testing.T) {
	_, instructions := StringToInstructions(inputStr)
	assert.Equal(t, "B", instructions["CH"], "they should be equal")
	assert.Equal(t, "C", instructions["CN"], "they should be equal")
}

func TestExpand(t *testing.T) {
	start, instructions := StringToInstructions(inputStr)
	assert.Equal(t, "NCNBCHB", Expand(start, instructions), "they should be equal")
}

func TestExpandMult(t *testing.T) {
	s, instructions := StringToInstructions(inputStr)
	s = Expand(s, instructions)
	assert.Equal(t, "NCNBCHB", s, "they should be equal")
	s = Expand(s, instructions)
	assert.Equal(t, "NBCCNBBBCBHCB", s, "they should be equal")
	s = Expand(s, instructions)
	assert.Equal(t, "NBBBCNCCNBBNBNBBCHBHHBCHB", s, "they should be equal")
	s = Expand(s, instructions)
	assert.Equal(t, "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB", s, "they should be equal")
}

func TestExpandCount(t *testing.T) {
	assert.Equal(t, ExpandCountOrig(inputStr, 0), ExpandCount(inputStr, 0), "they should be equal")
	assert.Equal(t, ExpandCountOrig(inputStr, 1), ExpandCount(inputStr, 1), "they should be equal")
	assert.Equal(t, ExpandCountOrig(inputStr, 2), ExpandCount(inputStr, 2), "they should be equal")
	assert.Equal(t, ExpandCountOrig(inputStr, 3), ExpandCount(inputStr, 3), "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 1588, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 2188189693529, Part2(inputStr), "they should be equal")
}
