package main

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var smStr = strings.TrimSpace(`
inp x
mul x -1
`)

var expectedSmStr = strings.TrimSpace(`
func Generated(input []int) [4]int {
idx := 0
register := [4]int{}
register[1] = input[idx]; idx++
register[1] *= -1
return register
}
`)

var medStr = strings.TrimSpace(`
inp z
inp x
mul z 3
eql z x
`)

var expectedMedStr = strings.TrimSpace(`
func Generated(input []int) [4]int {
idx := 0
register := [4]int{}
register[3] = input[idx]; idx++
register[1] = input[idx]; idx++
register[3] *= 3
if register[3] == register[1] { register[3] = 1 } else { register[3] = 0 }
return register
}
`)

var inputStr = strings.TrimSpace(`
inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
`)

var expectedInputStr = strings.TrimSpace(`
func Generated(input []int) [4]int {
idx := 0
register := [4]int{}
register[0] = input[idx]; idx++
register[3] += register[0]
register[3] %= 2
register[0] /= 2
register[2] += register[0]
register[2] %= 2
register[0] /= 2
register[1] += register[0]
register[1] %= 2
register[0] /= 2
register[0] %= 2
return register
}
`)

var aluTest = []struct {
	inputStr    string
	inputs      []int
	expected    [4]int
	description string
}{
	{smStr, []int{1}, [4]int{0, -1, 0, 0}, "Negates x input"},
	{smStr, []int{-1}, [4]int{0, 1, 0, 0}, "Negates x input"},
	{medStr, []int{4, 12}, [4]int{0, 12, 0, 1}, "Is three times larger"},
	{medStr, []int{4, 13}, [4]int{0, 13, 0, 0}, "Is not exactly three times larger"},
	{inputStr, []int{15}, [4]int{1, 1, 1, 1}, "Convert 4 bit number to binary"},
	{inputStr, []int{11}, [4]int{1, 0, 1, 1}, "Convert 4 bit number to binary"},
	{inputStr, []int{3}, [4]int{0, 0, 1, 1}, "Convert 4 bit number to binary"},
}

func TestAlu(t *testing.T) {
	for _, tt := range aluTest {
		t.Run(tt.description, func(t *testing.T) {
			actual := Alu(tt.inputStr, tt.inputs)
			if actual != tt.expected {
				t.Errorf("Alu(%#v) got %#v want %#v", tt.inputs, actual, tt.expected)
			}
		})
	}
}

var aluToGoTest = []struct {
	input       string
	expected    string
	description string
}{
	{smStr, expectedSmStr, "Negates x input"},
	{medStr, expectedMedStr, "Is three times larger"},
	{inputStr, expectedInputStr, "Convert 4 bit number to binary"},
}

func TestAluToGo(t *testing.T) {
	for _, tt := range aluToGoTest {
		t.Run(tt.description, func(t *testing.T) {
			actual := AluToGolang(tt.input)
			if actual != tt.expected {
				t.Errorf("AluToGolang() got %s want %s", actual, tt.expected)
			}
		})
	}
}

func TestToBin(t *testing.T) {
	assert.Equal(t, [4]int{1, 1, 1, 1}, ToBin([]int{15}), "they should be equal")
}

// What is the largest model number accepted by MONAD?
// func TestPart1(t *testing.T) {
// 	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
// }

var generatedTest = []struct {
	input       int
	expected    [4]int
	description string
}{
	{99997373333595, [4]int{5, 1, 14, 140983012}, "Generated 1"},
	{99997366666929, [4]int{9, 1, 18, 140967546}, "Generated 2"},
	{99997346666931, [4]int{1, 0, 0, 5420476}, "Generated 3"},
	{99997772478942, [4]int{2, 0, 0, 5422398}, "Generated 4"},
	{93997999296912, [4]int{2, 0, 0, 0}, "Largest Zero Val"},
	{81111379141811, [4]int{1, 0, 0, 0}, "Smallest Zero Val"},
}

func TestAluRules(t *testing.T) {
	for _, tt := range generatedTest {
		t.Run(tt.description, func(t *testing.T) {
			monadCode, err := os.ReadFile("input.txt")
			if err != nil {
				panic(err)
			}
			actual := Alu(string(monadCode), IntToDigits(tt.input))
			if actual != tt.expected {
				t.Errorf("Alu(%d) got %#v want %#v", tt.input, actual, tt.expected)
			}
		})
	}
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
