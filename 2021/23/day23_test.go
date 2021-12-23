package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
`)

func TestStringToState(t *testing.T) {
	state := StringToState(inputStr)
	// fmt.Println("Board:", state)
	assert.Equal(t, 0, state.energy, "they should be equal")
	assert.Equal(t, rune(65), state.board[14].typ, "they should be equal")
	assert.Equal(t, 2, state.board[14].id, "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
