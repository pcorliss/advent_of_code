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
	assert.Equal(t, rune(65), state.lizards[7].typ, "they should be equal")
	assert.Equal(t, Point{9, 3}, state.lizards[7].pos, "they should be equal")
}

var endState = strings.TrimSpace(`
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
`)

func TestValidEndState(t *testing.T) {
	state := StringToState(endState)
	assert.Equal(t, true, ValidEndState(state), "they should be equal")
}
func TestInValidEndState(t *testing.T) {
	state := StringToState(inputStr)
	assert.Equal(t, false, ValidEndState(state), "they should be equal")
}

var blockedStr = strings.TrimSpace(`
#############
#.A...C.....#
###.#.#B#D###
  #A#B#C#D#
  #########
`)

var colBlockedStr = strings.TrimSpace(`
#############
#AA.......DD#
###.#.#B#.###
  #.#B#C#C#
  #########
`)

var validDestTest = []struct {
	input       string
	beg         Point
	dest        Point
	expected    bool
	description string
}{
	{inputStr, Point{7, 2}, Point{0, 0}, false, "Invalid Point"},
	{inputStr, Point{7, 2}, Point{4, 1}, true, "Hallway is valid"},
	{inputStr, Point{7, 2}, Point{3, 2}, false, "Already Filled"},
	{blockedStr, Point{7, 2}, Point{5, 2}, false, "Hallway is blocked"},
	{blockedStr, Point{2, 1}, Point{3, 2}, true, "Hallway is not blocked"},
	{colBlockedStr, Point{2, 1}, Point{3, 2}, false, "Must move to bottom of column"},
	{colBlockedStr, Point{5, 3}, Point{3, 3}, false, "Must move to the correct column for that type"},
	{colBlockedStr, Point{10, 1}, Point{9, 2}, false, "Won't block in the wrong type of lizard"},
	{colBlockedStr, Point{2, 1}, Point{4, 1}, false, "Won't move around the hallway"},
	{colBlockedStr, Point{7, 3}, Point{4, 1}, false, "Can't move if blocked vertically"},
	{colBlockedStr, Point{5, 3}, Point{4, 1}, true, "Can move if not blocked vertically"},
	{colBlockedStr, Point{5, 3}, Point{5, 2}, false, "Can't move one space up and leave a gap"},
}

func TestValidDest(t *testing.T) {
	for _, tt := range validDestTest {
		t.Run(tt.description, func(t *testing.T) {
			state := StringToState(tt.input)
			actual := ValidDest(state, tt.beg, tt.dest)
			if actual != tt.expected {
				t.Errorf("ValidDest(%v, %v) got %t want %t", tt.beg, tt.dest, actual, tt.expected)
			}
		})
	}
}

var expectedStr = strings.TrimSpace(`
............
...B.C.B.D..
...A.D.C.A..
`)

// Wrong Energy
// Candidates: 2646
// Seen: 286
// Steps: 2
// Energy: 240
// ........B...
// ...B...C.D..
// ...A.D.C.A..

func TestStateToString(t *testing.T) {
	state := StringToState(inputStr)
	assert.Equal(t, expectedStr, StateToString(state), "they should be equal")
}

var calcDistTest = []struct {
	beg         Point
	dest        Point
	expected    int
	description string
}{
	{Point{3, 2}, Point{4, 1}, 2, "Calcs simple up and right"},
	{Point{3, 2}, Point{5, 3}, 5, "Calcs up and down"},
	{Point{5, 2}, Point{7, 2}, 4, "Calcs up and down mid"},
}

func TestCalcDistance(t *testing.T) {
	for _, tt := range calcDistTest {
		t.Run(tt.description, func(t *testing.T) {
			actual := CalcDistance(tt.beg, tt.dest)
			if actual != tt.expected {
				t.Errorf("CalcDistance(%v, %v) got %d want %d", tt.beg, tt.dest, actual, tt.expected)
			}
		})
	}
}

var step1Str = strings.TrimSpace(`
....B.......
...B.C...D..
...A.D.C.A..
`)

var step2Str = strings.TrimSpace(`
....B.......
...B...C.D..
...A.D.C.A..
`)

var step3Str = strings.TrimSpace(`
....B.D.....
...B...C.D..
...A...C.A..
`)

// Candidates: 2959
// Seen: 523
// Steps: 2
// Energy: 480
// ....B.......
// ...B...C.D..
// ...A.D.C.A..

// func TestFindLowestEnergy(t *testing.T) {
// 	state := StringToState(inputStr)
// 	assert.Equal(t, 12521, FindLowestEnergy(state), "they should be equal")
// }

func TestPart1(t *testing.T) {
	assert.Equal(t, 12521, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
