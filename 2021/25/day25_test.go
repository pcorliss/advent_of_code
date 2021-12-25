package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
`)

func TestStringToGrid(t *testing.T) {
	grid := StringToGrid(inputStr)
	assert.Equal(t, 1, grid.points[Point{0, 0}], "they should be equal")
	assert.Equal(t, 2, grid.points[Point{0, 2}], "they should be equal")
	assert.Equal(t, 0, grid.points[Point{0, 1}], "they should be equal")
	assert.Equal(t, Point{9, 8}, grid.max, "they should be equal")
	assert.Equal(t, Point{0, 0}, grid.min, "they should be equal")

}

func TestGridToString(t *testing.T) {
	grid := StringToGrid(inputStr)
	assert.Equal(t, inputStr, GridToString(grid), "They should be equal")
}

var step1Str = strings.TrimSpace(`
....>.>v.>
v.v>.>v.v.
>v>>..>v..
>>v>v>.>.v
.>v.v...v.
v>>.>vvv..
..v...>>..
vv...>>vv.
>.v.v..v.v
`)

var simpleStepStr = strings.TrimSpace(`
..........
.>v....v..
.......>..
..........
`)

var simpleStep1Str = strings.TrimSpace(`
..........
.>........
..v....v>.
..........
`)

var medStepStr = strings.TrimSpace(`
...>...
.......
......>
v.....>
......>
.......
..vvv..
`)

var medStep1Str = strings.TrimSpace(`
..vv>..
.......
>......
v.....>
>......
.......
....v..
`)

func TestStepSimple(t *testing.T) {
	grid := StringToGrid(simpleStepStr)
	newGrid, steps := Step(grid)
	assert.Equal(t, simpleStep1Str, GridToString(newGrid), "They should be equal")
	assert.Equal(t, 3, steps, "They should be equal")
}

func TestStepMed(t *testing.T) {
	grid := StringToGrid(medStepStr)
	newGrid, steps := Step(grid)
	// fmt.Println("Actual:\n", GridToString(newGrid))
	assert.Equal(t, medStep1Str, GridToString(newGrid), "They should be equal")
	assert.Equal(t, 5, steps, "They should be equal")
}

func TestStepComplex1(t *testing.T) {
	grid := StringToGrid(inputStr)
	newGrid, steps := Step(grid)
	assert.Equal(t, step1Str, GridToString(newGrid), "They should be equal")
	assert.Equal(t, 24, steps, "They should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 58, Part1(inputStr), "they should be equal")
}
func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
