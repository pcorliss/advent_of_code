package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("22/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 22")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Cube struct {
	x  int
	xp int

	y  int
	yp int

	z  int
	zp int

	state bool
}

func StringToInstructions(input string) []Cube {
	nums := []Cube{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, " ")
		rge := Cube{}
		rge.state = parts[0] == "on"
		for _, r := range strings.Split(parts[1], ",") {
			pieces := strings.Split(r, "=")
			vals := strings.Split(pieces[1], "..")
			a, _ := strconv.Atoi(vals[0])
			b, _ := strconv.Atoi(vals[1])
			switch pieces[0] {
			case "x":
				rge.x = a
				rge.xp = b
			case "y":
				rge.y = a
				rge.yp = b
			case "z":
				rge.z = a
				rge.zp = b
			default:
				panic("Unhandled piece")
			}
		}
		nums = append(nums, rge)
	}
	return nums
}

type Point struct {
	x int
	y int
	z int
}

func CubesSlow(insts []Cube, minmax int) int {
	cubes := make(map[Point]bool)
	count := 0
	minMax := Cube{}
	for _, inst := range insts {
		if inst.x < minMax.x {
			minMax.x = inst.x
		}
		if inst.xp > minMax.xp {
			minMax.xp = inst.xp
		}
		if inst.x < minMax.y {
			minMax.y = inst.y
		}
		if inst.xp > minMax.yp {
			minMax.yp = inst.yp
		}
		if inst.z < minMax.z {
			minMax.z = inst.z
		}
		if inst.zp > minMax.zp {
			minMax.zp = inst.zp
		}
		for x := inst.x; x <= inst.xp; x++ {
			if x > minmax || x < -minmax {
				continue
			}
			for y := inst.y; y <= inst.yp; y++ {
				if y > minmax || y < -minmax {
					continue
				}
				for z := inst.z; z <= inst.zp; z++ {
					if z > minmax || z < -minmax {
						continue
					}

					p := Point{x, y, z}
					if !cubes[p] && inst.state {
						cubes[p] = true
						count++
					} else if cubes[p] && !inst.state {
						cubes[p] = false
						count--
					}
				}
			}
		}
	}
	// fmt.Println("MinMax:", minMax)
	return count
}

func CubeIntersect(a, b Cube) bool {
	return !(a.xp < b.x ||
		b.xp < a.x ||
		a.zp < b.z ||
		b.zp < a.z ||
		a.yp < b.y ||
		b.yp < a.y)
}

func PointIntersect(x, y, z int, b Cube) bool {
	return !(x < b.x ||
		x > b.xp ||
		y < b.y ||
		y > b.yp ||
		z < b.z ||
		z > b.zp)
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func IntersectionVolume(a Cube, b Cube) int {
	// 12 - 10 == 2
	return (min(a.xp, b.xp) - max(a.x, b.x) + 1) *
		(min(a.yp, b.yp) - max(a.y, b.y) + 1) *
		(min(a.zp, b.zp) - max(a.z, b.z) + 1)
}

func CubesNew(insts []Cube, minmax int, steps int) int {
	count := 0

	boundaryCube := Cube{-minmax, minmax, -minmax, minmax, -minmax, minmax, true}
	boundaryVol := IntersectionVolume(boundaryCube, boundaryCube)
	newInst := []Cube{boundaryCube}
	for _, i := range insts {
		i.state = !i.state
		newInst = append(newInst, i)
	}

	for i, cube := range newInst {
		if i > steps && steps > 0 {
			// fmt.Println("Breaking on ", i)
			break
		}
		fmt.Println(i, cube)
		if i == 0 {
			// First cube is boundary box and is always on
			count += IntersectionVolume(cube, cube)
			// fmt.Println("  Count:", count)
		}
		for j := i - 1; j >= 0; j-- {
			priorCube := newInst[j]
			if !CubeIntersect(cube, priorCube) {
				continue
			}
			vol := -1 * IntersectionVolume(cube, priorCube)
			// if !cube.state {
			// 	vol *= -1
			// }
			if cube.state == priorCube.state {
				vol *= -1
			}
			count += vol
			fmt.Println("  Count:", boundaryVol-count, -vol, cube.state, priorCube)
		}
		// fmt.Println("    SubCount:", subCount)
	}

	return boundaryVol - count
}

func Cubes(insts []Cube, minmax int) int {
	return CubesSlow(insts, minmax)
}

func Part1(input string) int {
	inst := StringToInstructions(input)
	return Cubes(inst, 50)
}

func Part2(input string) int {
	return 0
}
