#!/usr/bin/env python

import argparse
import elffile # https://pypi.python.org/pypi/elffile
import os
import sys

def getData(section, wordLength):
    data = []
    buf = section.content

    tmp = 0
    for i in range(0, len(buf)):
        byte = ord(buf[i]) # transform the character to binary
        tmp |= byte << (8 * (i%wordLength)) # shift it into place in the word

        if i%wordLength == wordLength-1: # if this is the last byte in the word
            data.append(tmp)
            tmp = 0

    return data


def main(args):
    if not os.path.isfile(args.elf):
        print("Error: Cannot find file: {}".format(args.el))
        return 1
    else:
        with open(args.elf, 'rb') as f:
            ef = elffile.open(fileobj=f)
            section = None

            if args.section is None:
                # if no section was provided in the arguments list all available
                sections = [section.name for section in ef.sectionHeaders if section.name]
                print ("list of sections: {}".format(" ".join(sections)))
                return 0
            else:
                sections = [section for section in ef.sectionHeaders if section.name == args.section][:1]
                if len(sections) == 1:
                    section = sections[0]
                else:
                    section = None

            if not section:
                print ("error: could not find section with name: {}".format(args.section))
                return 0
            elif elffile.SHT.bycode[section.type] != elffile.SHT.byname["SHT_PROGBITS"]:
                print ("error: section has invalid type: {}".format(elffile.SHT.bycode[section.type]))
                return 0
            elif len(section.content) % args.length != 0:
                print ("error: {} data ({} bytes) does not align with a word length of {} bytes".format(section.name, len(section.content), args.length))
                return 0

            # get the binary data from the section and align it to words
            data = getData(section, args.length)

        # write the data by word to a readmem formatted file
        out = ""
        out += "// Converted from the {} section in {}\n".format(section.name, args.elf)
        out += "// $ {}\n".format(" ".join(sys.argv))
        out += "\n"

        counter = 0
        for word in data:
            out += "@{:08X} {:0{pad}X}\n".format(counter, word, pad=args.length*2)
            counter += args.addresses

        if args.output:
            # write the output to a file
            with open(args.output, "wb") as outputFile:
                outputFile.write(out)
        else:
            # write the output to stdout
            sys.stdout.write(out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract a section from an ELF to readmem format")
    parser.add_argument("-s", "--section", required=False, metavar="section", type=str, help="The name of the ELF section file to output")
    parser.add_argument("-o", "--output", required=False, metavar="output", type=str, help="The path to the output readmem file (default: stdout)")
    parser.add_argument("-l", "--length", required=False, metavar="length", type=int, help="The length of a memory word in number of bytes (default: 1)", default=1)
    parser.add_argument("-a", "--addresses", required=False, metavar="address", type=int, help="The number of addresses to increment per word", default=1)
    parser.add_argument("elf", metavar="elf-file", type=str, help="The input ELF file")
    args = parser.parse_args()

    main(args)