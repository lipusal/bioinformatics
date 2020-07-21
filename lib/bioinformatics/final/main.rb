# frozen_string_literal: true

require_relative 'options'
require_relative 'convolution'
require_relative 'spectrum'
require_relative 'score'

module Bioinformatics
  # Implementation of algorithms discussed in Chapter 4 of Bioinformatics Algorithms.
  # See https://www.bioinformaticsalgorithms.org/bioinformatics-chapter-4
  module Final
    class Main
      def run
        # puts Spectrum.new.cyclospectrum('KVAPSCKYELEL').sort.join(' ')
        # puts Score.new.score('NQEL', %w[0 99 113 114 128 227 257 299 355 356 370 371 484])

        args = Options.new.parse

        spectrum = (args[:spectrum] || args[:in].read.split("\n").first.chomp).split(' ')
        out = args[:out]

        convolution = Convolution.convolution(spectrum, true)
        top_masses = get_top_multiplicities(convolution, args[:top_masses])
        puts convolution.to_a.map { |k, v| "#{k}: #{v}"}.join(', ')
        puts top_masses.join(' ')
      end

      # Get the top MAX elements from ARY, disregarding ties (ie. ties don't add up to MAX, so resulting array
      # may contain more than MAX elements).
      def get_top_multiplicities(ary, max)
        sorted = ary.sort_by { |_k, v| -v }
        result = [sorted.first]
        inserted = 1
        i = 1
        while inserted < max && i < sorted.size
          _diff, multiplicity = sorted[i]
          result << sorted[i]
          i += 1
          # Don't count an additional inserted if the differences have equal multiplicity
          inserted += 1 if multiplicity < result[-2][1]
        end
        result.map { |diff, _multiplicity| diff }
      end


      def DELETE_ME
        # Example dataset from Rosalind
        # spectrum = %w[0 137 186 323]

        # Additional dataset from Rosalind
        # spectrum = %w[465 473 998 257 0 385 664 707 147 929 87 450 748 938 998 768 234 722 851 113 700 957 265 284 250 137 317 801 128 820 321 612 956 434 534 621 651 129 421 337 216 699 347 101 464 601 87 563 738 635 386 972 620 851 948 200 156 571 551 522 828 984 514 378 363 484 855 869 835 234 1085 764 230 885]

        # Theoretical spectrum from book
        spectrum = %w[0 113 114 128 129 227 242 242 257 355 356 370 371 484]

        # Experimental spectrum from book
        # spectrum = %w[0 99 113 114 128 227 257 299 355 356 370 371 484]

        # Test dataset from Rosalind
        # spectrum = %w[2183 364 1387 226 1865 1166 1231 1751 321 1768 1864 1190 1865 776 2263 1657 979 2141 866 113 1751 629 629 634 975 1752 1702 1863 478 1450 639 1392 2092 1117 1353 2278 322 704 689 2176 974 2164 1979 114 413 603 335 791 1529 114 1112 925 1279 1957 1145 639 341 939 1644 561 147 1714 1551 429 1053 2254 1316 1273 198 412 890 941 1762 726 623 526 1615 1038 677 285 1054 1830 1038 1314 1303 753 1913 1667 2070 316 188 2304 987 962 1514 342 2290 1337 753 101 113 113 2121 1374 1452 101 705 1614 1004 811 904 2278 1966 114 528 1801 1159 435 625 2037 1339 448 663 185 1416 542 200 549 2191 441 1601 735 2294 1580 1770 1252 324 1438 156 1757 413 1500 747 434 1031 848 775 211 527 2277 2206 753 591 1501 1849 1052 2078 2203 674 1864 840 1615 1687 128 2063 903 1553 2049 1543 1430 1487 1665 188 1139 1025 526 399 1479 1500 137 2278 776 2165 2205 1541 2278 2244 1686 724 2091 456 2150 1118 1412 227 1978 270 2056 1962 891 811 299 1017 1879 2205 1950 2079 1977 1225 1088 1525 1166 866 1338 1274 1404 2027 1978 1752 777 1160 1353 734 2075 354 961 1279 1246 2235 1717 2290 435 1303 1950 1328 1201 737 1728 827 1075 1488 2067 1902 1516 71 87 1762 2320 113 1175 2164 1870 1417 1638 1219 527 1430 1766 1224 640 1525 1751 312 1841 521 1467 1992 640 538 1580 97 1849 1366 1842 2050 951 1088 862 2165 2193 2180 1954 250 425 877 875 489 590 1564 0 1865 850 2203 1112 847 1656 333 1638 1429 1172 2051 1360 953 2058 437 1466 226 1638 1232 2391 1066 1440 999 87 2106 1058 1788 961 621 1865 300 1077 248 1956 1978 891 208 1661 1226 1638 340 1325 1956 550 1165 1544 2277 113 414 838 512 1853 924 2277 664 301 640 2278 2090 1333 227 1935 1225 730 790 1800 1303 186 215 2143 413 328 1216 1600 1088 2069 186 526 526 912 241 1167 542 1654 1727 2304 1943 313 1063 1616 441 753]

        result = Convolution.convolution(spectrum).join(' ')
        puts result
        # puts convolution_debug spectrum
        File.write('out.txt', result)
      end
    end

    # Automatically run if running class directly. Based on https://stackoverflow.com/a/2249332/2333689
    Main.new.run if __FILE__ == $PROGRAM_NAME
  end
end
