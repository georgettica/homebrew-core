class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://github.com/bbc/audiowaveform"
  url "https://github.com/bbc/audiowaveform/archive/1.8.1.tar.gz"
  sha256 "bd1254a4ddbc0eb68eb8dbd549335c3207260afdae4bf80cfe5d4129de51d1e7"
  license "GPL-3.0-or-later"

  depends_on "wget" => :test
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

  on_linux do
    resource "generate-random-audio" do
      url "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-unknown-linux-musl.tar.gz"
      sha256 "a066c9b760010f8ac711b7c88bd4a566ed1ab789234f1633d35dc4db654aab0c"
    end
  end
  on_macos do
    resource "generate-random-audio" do
      url "https://github.com/georgettica/generate-random-audio/releases/download/v0.1.11/generate-random-audio_v0.1.11_x86_64-apple-darwin.zip"
      sha256 "0072a0911eb070fa68d74573c9f233bc7dfa51ccb29eca04da79a9534e91542d"
    end
  end
  

  test do
    audiowaveform = bin/"audiowaveform"
    system audiowaveform, "--help"
    resource("generate-random-audio").stage do
      system "./generate-random-audio"
      assert "random_audio.wav", :exists?
    end
    system audiowaveform, "-i", "random_audio.wav", "-o", "random_audio.png"
    assert "random_audio.png", :exists?
  end
end
