class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://github.com/bbc/audiowaveform"
  url "https://github.com/bbc/audiowaveform/archive/1.8.1.tar.gz"
  sha256 "bd1254a4ddbc0eb68eb8dbd549335c3207260afdae4bf80cfe5d4129de51d1e7"
  license "GPL-3.0-or-later"

  depends_on "wget" => :test
  # if MacOS.version < :mavericks  depends_on "boost"
  # # => "c++11" end - commented out because of audit, maybe it's needed
  depends_on "boost"
  depends_on "cmake"
  depends_on "gd"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "mad"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"audiowaveform", "--help"
    if OS.linux?
      system "wget", "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-unknown-linux-musl.tar.gz"
      system "tar", "xf", "generate-random-audio_v0.1.11_x86_64-unknown-linux-musl.tar.gz"
    end
    if OS.mac?
      arr = 1..5
      arr.each do |i|
        zip_url = "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-apple-darwin.zip"
        (system "wget", zip_url) && break
        if i == 5
          puts "The command failed 5 times, crashing"
          exit 1
        end

        puts "sleeping for #{i*i} seconds"
        sleep i*i
      end
      system "unzip", "generate-random-audio_v0.1.11_x86_64-apple-darwin.zip"
    end
    system "./generate-random-audio"
    system bin/"audiowaveform", "-i", "random_audio.wav", "-o", "random_audio.png"
    assert "random_audio.png", :exists?
  end
end
