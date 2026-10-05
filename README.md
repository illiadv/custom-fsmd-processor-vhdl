# Custom FSMD Processor Module in VHDL

## Overview
This repository contains an RTL implementation of a custom digital processing module written in VHDL. The module is designed using the FSMD (Finite State Machine with Datapath) paradigm to execute signed integer multiplication and binary-to-BCD conversion.

This design was created as a course project for one of my university courses.

## Architecture
The architecture strictly separates data processing and control logic into different modules:
- Datapath (Execution Unit): Contains the registers, ALU and multiplexing logic. The datapath architecture was manually optimized by finding equivalence classes of micro-operations and sharing hardware resources between them.
- Control Unit: Implemented as a Microprogrammed ROM-based FSM with explicit next-state addressing.
