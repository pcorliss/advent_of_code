package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
Player 1 starting position: 4
Player 2 starting position: 8
`)

func TestStringToStarts(t *testing.T) {
	players := StringToStarts(inputStr)
	assert.Equal(t, 4, players[0].pos, "they should be equal")
	assert.Equal(t, 8, players[1].pos, "they should be equal")
	assert.Equal(t, 0, players[0].score, "they should be equal")
	assert.Equal(t, 0, players[1].score, "they should be equal")
}

func TestPlayRoundsUpdatesTheScoreAndPos(t *testing.T) {
	players := StringToStarts(inputStr)
	p, _ := PlayRounds(players, 1)
	assert.Equal(t, 10, p[0].pos, "they should be equal")
	assert.Equal(t, 8, p[1].pos, "they should be equal")
	assert.Equal(t, 10, p[0].score, "they should be equal")
	assert.Equal(t, 0, p[1].score, "they should be equal")
}

func TestPlayRoundsHandlesBothPlayers(t *testing.T) {
	players := StringToStarts(inputStr)
	p, _ := PlayRounds(players, 331)
	assert.Equal(t, 10, p[0].pos, "they should be equal")
	assert.Equal(t, 3, p[1].pos, "they should be equal")
	assert.Equal(t, 1000, p[0].score, "they should be equal")
	assert.Equal(t, 745, p[1].score, "they should be equal")
}

func TestPlayRoundsStopsOnWin(t *testing.T) {
	players := StringToStarts(inputStr)
	p, rolls := PlayRounds(players, 332)
	assert.Equal(t, 10, p[0].pos, "they should be equal")
	assert.Equal(t, 3, p[1].pos, "they should be equal")
	assert.Equal(t, 1000, p[0].score, "they should be equal")
	assert.Equal(t, 745, p[1].score, "they should be equal")
	assert.Equal(t, 993, rolls, "they should be equal")
}

func TestPlayQuantumRounds(t *testing.T) {
	players := StringToStarts(inputStr)
	scoreA, scoreB := PlayQuantumRounds(players, 1)
	assert.Equal(t, 27, scoreA, "they should be equal")
	assert.Equal(t, 0, scoreB, "they should be equal")
}

func TestPlayQuantumRounds2(t *testing.T) {
	players := StringToStarts(inputStr)
	scoreA, scoreB := PlayQuantumRounds(players, 2)
	assert.Equal(t, 183, scoreA, "they should be equal")
	assert.Equal(t, 156, scoreB, "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 739785, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 444356092776315, Part2(inputStr), "they should be equal")
}
