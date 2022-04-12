class Hphi < Formula
  desc "Quantum Lattice Model Simulator Package"
  homepage "https://github.com/issp-center-dev/HPhi"
  url "https://github.com/issp-center-dev/HPhi/releases/download/v3.5.0/HPhi-3.5.0.tar.gz"
  sha256 "9510cd87319f56762b6be23c87effe4ed3d22cbda99a36b6c226ed463df055d1"
  license ""

  depends_on "cmake" => :build
  depends_on "gfortran" => :build
  depends_on "libomp"
  depends_on "openmpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    open("stan.in", "w") do |f|
      f.puts('model = "spin"')
      f.puts("J = 1")
      f.puts("2S = 1")
      f.puts("2Sz = 0")
      f.puts('lattice = "chain"')
      f.puts("L = 8")
      f.puts('method = "cg"')
    end
    system "#{bin}/HPhi", "-s", "stan.in"
  end
end
