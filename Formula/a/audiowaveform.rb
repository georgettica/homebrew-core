class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://github.com/bbc/audiowaveform"
  url "https://github.com/bbc/audiowaveform/archive/1.8.1.tar.gz"
  sha256 "bd1254a4ddbc0eb68eb8dbd549335c3207260afdae4bf80cfe5d4129de51d1e7"
  license "GPL-3.0-or-later"

  # if MacOS.version < :mavericks  depends_on "boost"
  # # => "c++11" end - commented out because of audit, maybe it's needed
  depends_on "boost"

  depends_on "cmake"
  depends_on "gd"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "mad"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DENABLE_TESTS=0"
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

    if OS.mac?
      cmake_args << "-DCMAKE_C_COMPILER=/usr/bin/clang"
      cmake_args << "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"audiowaveform", "--help"
    if OS.linux?
      system "wget", "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-unknown-linux-musl.tar.gz"
      system "tar", "xf", "generate-random-audio_v0.1.11_x86_64-unknown-linux-musl.tar.gz"
    end
    if OS.mac?
      system "wget", "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-apple-darwin.zip"
      system "unzip", "generate-random-audio_v0.1.11_x86_64-apple-darwin.zip"
    end
    system "./generate-random-audio"
    system bin/"audiowaveform", "-i", "random_audio.wav", "-o", "random_audio.png"
    system "file", "random_audio.png"
  end
end
