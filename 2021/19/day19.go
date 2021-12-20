package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("19/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 19")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
	z int
}

type Sensor struct {
	readings []Point
}

func StringToSensors(input string) []Sensor {
	sensors := []Sensor{}
	lines := strings.Split(input, "\n")
	var curSensor Sensor
	for j, line := range lines {
		if len(line) == 0 {
			continue
		}
		if strings.Contains(line, "---") {
			if j > 0 {
				sensors = append(sensors, curSensor)
			}
			curSensor = Sensor{[]Point{}}
			continue
		}
		point := Point{}
		for i, dim := range strings.Split(line, ",") {
			n, err := strconv.Atoi(dim)
			if err != nil {
				panic(err)
			}
			switch i {
			case 0:
				point.x = n
			case 1:
				point.y = n
			case 2:
				point.z = n
			default:
				panic("Too many entries in line")
			}
		}
		curSensor.readings = append(curSensor.readings, point)
	}
	sensors = append(sensors, curSensor)
	return sensors
}

func SameOct(a, b Point) bool {
	return math.Signbit(float64(a.x)) == math.Signbit(float64(b.x)) && math.Signbit(float64(a.y)) == math.Signbit(float64(b.y)) && math.Signbit(float64(a.z)) == math.Signbit(float64(b.z))
}

func CalcBeaconToBeaconDistance(readings []Point) map[int][]Point {
	distance := make(map[int][]Point)
	calculated := make(map[Point]bool)
	for _, a := range readings {
		calculated[a] = true
		for _, b := range readings {
			if a == b {
				continue
			}
			if calculated[b] {
				continue
			}
			dist := int(math.Abs(float64(a.x-b.x)) + math.Abs(float64(a.y-b.y)) + math.Abs(float64(a.z-b.z)))
			distance[dist] = []Point{a, b}
		}
	}
	return distance
}

func CompareDistancesBetweenSensors(sensors []Sensor) {
	distances := []map[int][]Point{}
	for _, s := range sensors {
		distance := CalcBeaconToBeaconDistance(s.readings)
		distances = append(distances, distance)
	}

	for i := range sensors {
		for j := range sensors {
			match := 0
			if j <= i {
				continue
			}

			candidates := make(map[Point]map[Point]int)
			for dist := range distances[i] {
				if _, exists := distances[j][dist]; exists {
					match++
					if candidates[distances[i][dist][0]] == nil {
						candidates[distances[i][dist][0]] = make(map[Point]int)
					}
					if candidates[distances[i][dist][1]] == nil {
						candidates[distances[i][dist][1]] = make(map[Point]int)
					}
					candidates[distances[i][dist][0]][distances[j][dist][0]]++
					candidates[distances[i][dist][0]][distances[j][dist][1]]++
					candidates[distances[i][dist][1]][distances[j][dist][0]]++
					candidates[distances[i][dist][1]][distances[j][dist][1]]++
				}
			}
			pointMatches := make(map[Point]Point)
			for pointA, potentials := range candidates {
				maxPoint := Point{}
				maxCount := 0
				for pointB, count := range potentials {
					if count == maxCount {
						maxCount = 0
						continue
					}
					if maxCount == 0 || count > maxCount {
						maxPoint = pointB
						maxCount = count
					}
				}
				// Not sure if this is significant
				// Found some dupe matche vals
				// But there should only be one????
				if maxCount > 2 {
					pointMatches[pointA] = maxPoint
					// fmt.Println("Matched:", pointA, maxPoint, maxCount, potentials)
				}
			}

			// Not sure if 12 is meaningful here or not...
			if len(pointMatches) >= 12 {
				// fmt.Println("Found ", match, "matches between", i, "and", j)
				// fmt.Println("Found point matches: ", len(pointMatches))
			} else {
				continue
			}

			fmt.Println("Sensors:", i, j)
			var matrix Point
			var shift Point
			var transforms [][]int
			found := false
			for dist := range distances[i] {
				if _, exists := distances[j][dist]; exists {
					pointA := distances[i][dist][0]
					pointB := distances[i][dist][1]

					pointW := distances[j][dist][0]
					pointU := distances[j][dist][1]

					if _, exists := pointMatches[pointA]; !exists {
						continue
					}
					if _, exists := pointMatches[pointB]; !exists {
						continue
					}
					if !(pointMatches[pointA] == pointW && pointMatches[pointB] == pointU) {
						pointW, pointU = pointU, pointW
					}
					if pointMatches[pointA] == pointW && pointMatches[pointB] == pointU {
						fmt.Println(pointA, pointB, pointU, pointW)
						vectorAB := Point{pointB.x - pointA.x, pointB.y - pointA.y, pointB.z - pointA.z}
						vectorWU := Point{pointU.x - pointW.x, pointU.y - pointW.y, pointU.z - pointW.z}

						// Confirm once and break
						if found {
							m, t := VectorsToTransform(vectorAB, vectorWU)
							if m != matrix || len(t) != len(transforms) {
								panic("Found Matrix and Transform mismatch")
							}
							s := CalcShift(pointA, pointW, matrix, transforms)
							if s != shift {
								panic("Found Shift mismatch")
							}
							break
						} else {
							// Get vector transition
							matrix, transforms = VectorsToTransform(vectorAB, vectorWU)
							shift = CalcShift(pointA, pointW, matrix, transforms)
							found = true
						}
						fmt.Println("  Vectors:", vectorAB, vectorWU)
						fmt.Println("  Matrix: ", matrix, "Transforms:", transforms, "Shift:", shift)
					}
				}
			}
		}
	}
}

func CalcShift(a Point, b Point, matrix Point, transform [][]int) Point {
	t := ApplyTransform(b, matrix, transform)
	return Point{
		t.x - a.x,
		t.y - a.y,
		t.z - a.z,
	}
}

func ApplyTransform(p Point, matrix Point, transforms [][]int) Point {
	transformed := p
	for _, transform := range transforms {
		val := 0
		switch transform[1] {
		case 0:
			val = p.x
		case 1:
			val = p.y
		case 2:
			val = p.z
		default:
			panic("Switch Failure on Transform")
		}
		switch transform[0] {
		case 0:
			transformed.x = val
		case 1:
			transformed.y = val
		case 2:
			transformed.z = val
		default:
			panic("Switch Failure on Transform")
		}
	}
	transformed.x *= matrix.x
	transformed.y *= matrix.y
	transformed.z *= matrix.z
	return transformed
}

func VectorsToTransform(a, w Point) (Point, [][]int) {
	transforms := [][]int{}
	if math.Abs(float64(a.x)) != math.Abs(float64(w.x)) {
		if math.Abs(float64(a.x)) == math.Abs(float64(w.y)) {
			transforms = append(transforms, []int{0, 1})
		} else if math.Abs(float64(a.x)) == math.Abs(float64(w.z)) {
			transforms = append(transforms, []int{0, 2})
		} else {
			panic("Should not get here. Vector x didn't match x,y or z")
		}
	}
	if math.Abs(float64(a.y)) != math.Abs(float64(w.y)) {
		if math.Abs(float64(a.y)) == math.Abs(float64(w.x)) {
			transforms = append(transforms, []int{1, 0})
		} else if math.Abs(float64(a.y)) == math.Abs(float64(w.z)) {
			transforms = append(transforms, []int{1, 2})
		} else {
			panic("Should not get here. Vector x didn't match x,y or z")
		}
	}
	if math.Abs(float64(a.z)) != math.Abs(float64(w.z)) {
		if math.Abs(float64(a.z)) == math.Abs(float64(w.x)) {
			transforms = append(transforms, []int{2, 0})
		} else if math.Abs(float64(a.z)) == math.Abs(float64(w.y)) {
			transforms = append(transforms, []int{2, 1})
		} else {
			panic("Should not get here. Vector x didn't match x,y or z")
		}
	}

	transformed := ApplyTransform(w, Point{1, 1, 1}, transforms)

	if math.Abs(float64(a.x)) != math.Abs(float64(transformed.x)) || math.Abs(float64(a.y)) != math.Abs(float64(transformed.y)) || math.Abs(float64(a.z)) != math.Abs(float64(transformed.z)) {
		fmt.Println("Mismatch between a and tranformed", a, transformed)
		panic("Mismatch between transformed vector")
	}

	matrix := Point{1, 1, 1}
	if a.x != transformed.x {
		matrix.x = -1
	}
	if a.y != transformed.y {
		matrix.y = -1
	}
	if a.z != transformed.z {
		matrix.z = -1
	}

	return matrix, transforms
}

func Part1(input string) int {
	sensors := StringToSensors(input)
	CompareDistancesBetweenSensors(sensors)
	return 0
}

func Part2(input string) int {
	return 0
}
