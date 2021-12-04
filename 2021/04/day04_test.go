package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
`)

func TestIngestNums(t *testing.T) {
	expectedNums := []int{7, 4, 9, 5, 11}
	assert.Equal(t, 27, len(StringToBingo(inputStr)), "they should be equal")
	assert.Equal(t, expectedNums, StringToBingo(inputStr)[0:5], "they should be equal")
}

func TestIngestBoards(t *testing.T) {
	expectedLastLine := [5]int{2, 0, 12, 3, 7}
	assert.Equal(t, 3, len(StringToBoards(inputStr)), "they should be equal")
	assert.Equal(t, expectedLastLine, StringToBoards(inputStr)[2][4], "they should be equal")
}

func TestWinningBoardsHorizontal(t *testing.T) {
	board := StringToBoards(inputStr)[0]
	calledNums := map[int]bool{8: true, 2: true, 23: true, 4: true, 24: true}
	assert.Equal(t, true, WinningBoard(calledNums, board), "they should be equal")
}

func TestWinningBoardsVertical(t *testing.T) {
	board := StringToBoards(inputStr)[0]
	calledNums := map[int]bool{17: true, 23: true, 14: true, 3: true, 20: true}
	assert.Equal(t, true, WinningBoard(calledNums, board), "they should be equal")
}

func TestWinningBoardsDiagonal(t *testing.T) {
	// Diagonals don't count
	board := StringToBoards(inputStr)[0]
	calledNums := map[int]bool{1: true, 10: true, 14: true, 4: true, 0: true}
	assert.Equal(t, false, WinningBoard(calledNums, board), "they should be equal")
}

func TestLosingBoards(t *testing.T) {
	board := StringToBoards(inputStr)[0]
	calledNums := map[int]bool{2: true, 23: true, 4: true, 24: true}
	assert.Equal(t, false, WinningBoard(calledNums, board), "they should be equal")
}

func TestSumUnmarked(t *testing.T) {
	board := StringToBoards(inputStr)[0]
	calledNums := map[int]bool{1: true, 10: true, 14: true, 4: true, 0: true}
	assert.Equal(t, 271, SumUnmarked(calledNums, board), "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 188, Part1(inputStr)[0], "they should be equal")
	assert.Equal(t, 4512, Part1(inputStr)[1], "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 148, Part2(inputStr)[0], "they should be equal")
	assert.Equal(t, 1924, Part2(inputStr)[1], "they should be equal")
}
