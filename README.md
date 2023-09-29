# FPGA-based Implementation of Convolutional Neural Network

Convolutional Neural Networks (CNNs) have been in use since 1980s; However,
the major breakthroughts in image recognition came in 2012 when Microsoft
Research introduced AlexNet. Then in 2014, ResNet was introduced which solved
the issues of vanishing gradient with the previous CNNs when the layers went deep.

In many areas (name a few), Image Recognition requires fast inference, low-power
consumption if used in small devices. All these requirements can simply
not be filled with the slow but cheap Software-based Implementation of CNNs,
and can barely be the filled with the energy and cost expensive GPUs.

(Write 'What is an FPGA?')

FPGAs solve all these problems: Faster than Software-based as well as GPU-based CNNs.
Less energy consumption as compared to GPUs.

In this project, we are not only building a CNN from scratch, but also a RISC-V
Processor from scratch. We will join these together, resulting in a complete
system. Then this system will be deployed on an FPGA-chip.

(Write 'What is RISC-V?')

The performance will be cross-tested with other forms of implementations:
CNN with Tensorflow, CNN with Python, CNN with C, and lastly our CNN on FPGA.
