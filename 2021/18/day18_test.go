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
