package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("24/input.txt")
	if err != nil {
		panic(err)
	}

	// fmt.Println("Generated Go Code:")
	// fmt.Println(AluToGolang(string(inputStr)))

	fmt.Println("Day 24")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	// fmt.Println("Part 02")
	// fmt.Println("Result: ", Part2(string(inputStr)))
}

// This would be better as a ascii code - 85 sort of things
// But this is easier and faster to write.
var registerLookup = map[string]int{
	"w": 0,
	"x": 1,
	"y": 2,
	"z": 3,
}

func AluToGolang(input string) string {
	out := []string{
		"func Generated(input []int) [4]int {",
		"idx := 0",
		"register := [4]int{}",
	}
	for _, line := range strings.Split(input, "\n") {
		parts := strings.Split(line, " ")
		registerIdx := registerLookup[parts[1]]
		val_or_register := ""
		if len(parts) > 2 {
			_, err := strconv.Atoi(parts[2])
			if err == nil {
				// Val
				val_or_register = parts[2]
			} else {
				// Register ...
				registerIdx2 := registerLookup[parts[2]]
				val_or_register = "register[" + fmt.Sprint(registerIdx2) + "]"
			}
		}
		cmd := ""
		switch parts[0] {
		case "inp":
			cmd = "register[" + fmt.Sprint(registerIdx) + "] = input[idx]; idx++"
		case "mul":
			cmd = "register[" + fmt.Sprint(registerIdx) + "] *= " + val_or_register
		case "add":
			cmd = "register[" + fmt.Sprint(registerIdx) + "] += " + val_or_register
		case "div":
			cmd = "register[" + fmt.Sprint(registerIdx) + "] /= " + val_or_register
		case "mod":
			cmd = "register[" + fmt.Sprint(registerIdx) + "] %= " + val_or_register
		case "eql":
			cmd = "if register[" + fmt.Sprint(registerIdx) + "] == " + val_or_register + " { register[" + fmt.Sprint(registerIdx) + "] = 1 } else { register[" + fmt.Sprint(registerIdx) + "] = 0 }"
		default:
			fmt.Println("Unrecognized Instruction:", parts)
			panic("Unrecognized instruction")
		}
		out = append(out, cmd)
	}
	out = append(out, "return register")
	out = append(out, "}")
	return strings.Join(out, "\n")
}

func Alu(input string, vars []int) [4]int {
	register := [4]int{}
	inputCount := 0
	for _, line := range strings.Split(input, "\n") {
		parts := strings.Split(line, " ")
		registerIdx := registerLookup[parts[1]]
		registerIdx2 := 0
		val2 := 0
		if len(parts) > 2 {
			idx, exists := registerLookup[parts[2]]
			if exists {
				registerIdx2 = idx
				val2 = register[registerIdx2]
			} else {
				num, err := strconv.Atoi(parts[2])
				if err == nil {
					val2 = num
				} else {
					panic("Unable to parse instruction")
				}
			}
		}
		switch parts[0] {
		case "inp":
			register[registerIdx] = vars[inputCount]
			inputCount++
		case "mul":
			register[registerIdx] *= val2
		case "add":
			register[registerIdx] += val2
		case "div":
			register[registerIdx] /= val2
		case "mod":
			register[registerIdx] %= val2
		case "eql":
			if register[registerIdx] == val2 {
				register[registerIdx] = 1
			} else {
				register[registerIdx] = 0
			}
		default:
			fmt.Println("Unrecognized Instruction:", parts)
			panic("Unrecognized instruction")
		}
		// fmt.Println("Inst:", parts, "Result:", register)
	}
	return register
}

func ToBin(input []int) [4]int {
	idx := 0
	registers := [4]int{}
	registers[0] = input[idx]
	idx++
	registers[3] += registers[0]
	registers[3] %= 2
	registers[0] /= 2
	registers[2] += registers[0]
	registers[2] %= 2
	registers[0] /= 2
	registers[1] += registers[0]
	registers[1] %= 2
	registers[0] /= 2
	registers[0] %= 2
	return registers
}

func IntToDigits(in int) []int {
	out := [14]int{}
	for i := 0; i < 14; i++ {
		digit := in % 10
		in -= digit
		in /= 10
		out[14-i-1] = digit
	}
	return out[:]
}

func containsZero(in []int) bool {
	for _, d := range in {
		if d == 0 {
			return true
		}
	}
	return false
}

// What is the largest model number accepted by MONAD?
func Part1(input string) int {
	num := 99999999999999
	for num > 0 {
		digits := IntToDigits(num)
		for containsZero(digits) {
			num--
			digits = IntToDigits(num)
		}
		out := Generated(digits)
		if out[3] == 0 {
			return num
		}
		if num%3333333 == 0 {
			fmt.Println("Tried:", num)
			fmt.Println("Out:", out)
		}
		num--
	}
	return -1
}

func Part2(input string) int {
	return 0
}

func Generated(input []int) [4]int {
	idx := 0
	register := [4]int{}
	register[0] = input[idx] // r0 = inp
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 10 // r1 = 10
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	} // r1 = 1
	register[2] *= 0
	register[2] += 25 // r2 = 25
	register[2] *= register[1]
	register[2] += 1 // r2 = 26
	register[3] *= register[2]
	register[2] *= 0           // r2 = 0
	register[2] += register[0] // r2 = r0
	register[2] += 2           // r2 += 2
	register[2] *= register[1] // r2 = (in0 + 2) * 10
	register[3] += register[2] // r3 = (in0 + 2) * 10

	// r0 = inp
	// r1 = r3
	//

	register[0] = input[idx] // in1
	idx++
	register[1] *= 0
	register[1] += register[3] // r1 = (in0 + 2) * 10
	register[1] %= 26          // r1 %= 26
	register[3] /= 1
	register[1] += 14
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 13
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 14
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 13
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -13
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 9
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 10
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 15
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -13
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 3
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -7
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 6
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 11
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 5
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 10
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 16
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 1
	register[1] += 13
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 1
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -4
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 6
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -9
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 3
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -13
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 7
	register[2] *= register[1]
	register[3] += register[2]
	register[0] = input[idx]
	idx++
	register[1] *= 0
	register[1] += register[3]
	register[1] %= 26
	register[3] /= 26
	register[1] += -9
	if register[1] == register[0] {
		register[1] = 1
	} else {
		register[1] = 0
	}
	if register[1] == 0 {
		register[1] = 1
	} else {
		register[1] = 0
	}
	register[2] *= 0
	register[2] += 25
	register[2] *= register[1]
	register[2] += 1
	register[3] *= register[2]
	register[2] *= 0
	register[2] += register[0]
	register[2] += 9
	register[2] *= register[1]
	register[3] += register[2]
	return register
}
