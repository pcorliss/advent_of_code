package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
`)

func TestStringToLines(t *testing.T) {
	assert.Equal(t, 10, len(StringToLines(inputStr)), "they should be equal")
	assert.Equal(t, 9, StringToLines(inputStr)[0].a.y, "they should be equal")
	assert.Equal(t, 5, StringToLines(inputStr)[0].b.x, "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 5, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 12, Part2(inputStr), "they should be equal")
}
