class Wordfreq
  STOP_WORDS = ['a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'for', 'from',
    'has', 'he', 'i', 'in', 'is', 'it', 'its', 'of', 'on', 'that', 'the', 'to',
    'were', 'will', 'with']

  def initialize(filename)
    @filename = filename

    #Stores file as array of lines, lowercase with punctuation removed
    @words = File.open(filename).map {|line| line.downcase .gsub /([,:;!.])+/, ""}
    @words = @words.map{|line| line.gsub /(--)+/, " "}
  end

  def frequency(word)
    freq_words = 0
    @words.map {|line| freq_words += line.scan(/(\s#{word}\s)+/).length}
    freq_words
  end

  def frequencies
    result = Hash.new()

    #Put every word in file into array
    array_words = []
    @words.each do |line|
      line.scan(/(\w+)+/).map {|word| array_words.push(word[0].to_s)}
    end

    #remove stop words
    array_words -= STOP_WORDS

    array_words.each do |word|
      if(result[word].nil?)
        result[word] = 1
      else
        result[word] = result[word].to_i + 1
      end
    end

    result

  end

  def top_words(number)
    result = frequencies.sort_by {|k, v| v}.reverse
    result.take(number)
  end

  def print_report
    top10 = top_words(10)
    result = top10.each do |key, value|
      stars = "*" * value.to_i
      printf("\n %5s | %1d %1s ", key, value, stars)
    end
  end
end

if __FILE__ == $0
  filename = ARGV[0]
  if filename
    full_filename = File.absolute_path(filename)
    if File.exists?(full_filename)
      wf = Wordfreq.new(full_filename)

      ##DEBUG
      wf.top_words(8)
      wf.frequencies
      wf.print_report
    else
      puts "#{filename} does not exist!"
    end
  else
    puts "Please give a filename as an argument."
  end
end
