# Hardware-Acceleration-Vanilla-RNN-on-Zynq-UltraScale-MPSoC102


## Overview

This project implements a configurable Vanilla Recurrent Neural Network (RNN) using Verilog HDL. The design performs recurrent hidden-state computation and activation processing in hardware, demonstrating FPGA-oriented machine learning acceleration techniques.

## Features

- Parameterized RTL architecture
- Configurable input and hidden dimensions
- Recurrent hidden-state computation
- Hardware-friendly activation approximation
- Synthesizable Verilog implementation
- FPGA prototyping ready

## Architecture

h(t) = tanh(Wx·x(t) + Wh·h(t−1) + b)

The design computes the hidden state iteratively using input vectors, recurrent weights, and bias terms.

## Applications

- Sequence Processing
- Time-Series Analysis
- Edge AI
- FPGA-based ML Acceleration
- Embedded Machine Learning

## Tools

- Verilog HDL
- Vivado
