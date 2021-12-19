package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
[1,2]
[[1,2],3]
[9,[8,7]]
[[1,9],[8,5]]
[[[[1,2],[3,4]],[[5,6],[7,8]]],9]
[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
`)

// If any pair is nested inside four pairs, the leftmost such pair explodes.
// If any regular number is 10 or greater, the leftmost such regular number splits.

func TestStringToTree(t *testing.T) {
	trees := StringToTree(inputStr)
	assert.Equal(t, 7, len(trees), "they should be equal")
}

func TestStringToTreeRegularNumbers(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[0]
	// fmt.Println("Tree:", tree, tree.left, tree.left.right)
	assert.Equal(t, 1, tree.left.data, "they should be equal")
	assert.Equal(t, 2, tree.right.data, "they should be equal")
}

func TestStringToTreeSingleNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[1]
	// fmt.Println("Tree:", tree, tree.left.left, tree.left.right, tree.right)
	assert.Equal(t, 1, tree.left.left.data, "they should be equal")
	assert.Equal(t, 2, tree.left.right.data, "they should be equal")
	assert.Equal(t, 3, tree.right.data, "they should be equal")
}

func TestStringToTreeSingleNestedRight(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[2]
	// fmt.Println("Tree:", tree, tree.left, tree.right)
	assert.Equal(t, 9, tree.left.data, "they should be equal")
	assert.Equal(t, 8, tree.right.left.data, "they should be equal")
	assert.Equal(t, 7, tree.right.right.data, "they should be equal")
}

func TestStringToTreeDoubleNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[3]
	// fmt.Println("Tree:", tree, tree.left, tree.right)
	assert.Equal(t, 1, tree.left.left.data, "they should be equal")
	assert.Equal(t, 9, tree.left.right.data, "they should be equal")
	assert.Equal(t, 8, tree.right.left.data, "they should be equal")
	assert.Equal(t, 5, tree.right.right.data, "they should be equal")
}

// [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
func TestStringToTreeQuadNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[4]
	assert.Equal(t, 1, tree.left.left.left.left.data, "they should be equal")
	assert.Equal(t, 2, tree.left.left.left.right.data, "they should be equal")
	assert.Equal(t, 3, tree.left.left.right.left.data, "they should be equal")
	assert.Equal(t, 4, tree.left.left.right.right.data, "they should be equal")
	assert.Equal(t, 5, tree.left.right.left.left.data, "they should be equal")
	assert.Equal(t, 6, tree.left.right.left.right.data, "they should be equal")
	assert.Equal(t, 7, tree.left.right.right.left.data, "they should be equal")
	assert.Equal(t, 8, tree.left.right.right.right.data, "they should be equal")
	assert.Equal(t, 9, tree.right.data, "they should be equal")
}

// [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
func TestStringToTreeComplex(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[5]
	assert.Equal(t, 9, tree.left.left.left.data, "they should be equal")
	assert.Equal(t, 3, tree.left.left.right.left.data, "they should be equal")
	assert.Equal(t, 8, tree.left.left.right.right.data, "they should be equal")

	assert.Equal(t, 0, tree.left.right.left.left.data, "they should be equal")
	assert.Equal(t, 9, tree.left.right.left.right.data, "they should be equal")
	assert.Equal(t, 6, tree.left.right.right.data, "they should be equal")

	assert.Equal(t, 3, tree.right.left.left.left.data, "they should be equal")
	assert.Equal(t, 7, tree.right.left.left.right.data, "they should be equal")
	assert.Equal(t, 4, tree.right.left.right.left.data, "they should be equal")
	assert.Equal(t, 9, tree.right.left.right.right.data, "they should be equal")

	assert.Equal(t, 3, tree.right.right.data, "they should be equal")
}

func TestTreeToString(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[5]
	expected := "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"
	assert.Equal(t, expected, TreeToString(*tree), "they should be equal")
}

var explodeTests = []struct {
	input       string
	expected    string
	description string
}{
	{"[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]", "(the 9 has no regular number to its left, so it is not added to any regular number)."},
	{"[7,[6,[5,[4,[3,2]]]]]", "[7,[6,[5,[7,0]]]]", "(the 2 has no regular number to its right, and so it is not added to any regular number)."},
	{"[[6,[5,[4,[3,2]]]],1]", "[[6,[5,[7,0]]],3]", ""},
	{"[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "(the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action)."},
	{"[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]", ""},
	{"[[[[0,7],4],[7,[[8,4],9]]],[1,1]]", "[[[[0,7],4],[15,[0,13]]],[1,1]]", "complex explode"},
}

func TestTreeExplode(t *testing.T) {
	for _, tt := range explodeTests {
		t.Run(tt.description, func(t *testing.T) {
			trees := StringToTree(tt.input)
			tree := trees[0]
			actual := TreeToString(TreeExplode(*tree))
			if actual != tt.expected {
				t.Errorf("TreeExplode(%s) got %s, want %s", tt.input, actual, tt.expected)
			}
		})
	}
}

var splitTests = []struct {
	input       string
	expected    string
	description string
}{
	{"[[[[[0,9],9],0],0],0]", "[[[[0,[9,9]],0],0],0]", "Even Numbers"},
	{"[[[[[0,8],9],0],0],0]", "[[[[0,[8,9]],0],0],0]", "Odd Numbers"},
}

func TestTreeSplit(t *testing.T) {
	for _, tt := range splitTests {
		t.Run(tt.description, func(t *testing.T) {
			trees := StringToTree(tt.input)
			tree := trees[0]
			explodedTree := TreeExplode(*tree)
			actual := TreeToString(TreeSplit(explodedTree))
			if actual != tt.expected {
				t.Errorf("TreeSplit(%s) got %s, want %s", tt.input, actual, tt.expected)
			}
		})
	}
}

func TestTreeReduce(t *testing.T) {

}

func TestPart1(t *testing.T) {
	// for i := 0; i < 257; i++ {
	// 	fmt.Print(i, " ", int8(i), " ", uint8(i), ",")
	// }

	// a := uint8(0)
	// b := uint16(0)
	// c := uint32(0)
	// d := uint64(0)
	// e := uint(0)
	// fmt.Println(a-1, b-1, c-1, d-1, e-1)

	// a := 9
	// a = nil
	// fmt.Println(a)
	assert.Equal(t, 0, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
