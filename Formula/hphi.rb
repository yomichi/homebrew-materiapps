class Hphi < Formula
  desc "Quantum Lattice Model Simulator Package"
  homepage "http://qlms.github.io/HPhi/index_en.html"
  url "https://github.com/QLMS/HPhi/releases/download/v2.0.0/HPhi-2.0.0.tar.gz"
  sha256 "e1530c0178ba4d5d9d0c4b4af719af951f8ff26684f70b92baf26d8c60e97232"

  depends_on "cmake" => :build
  depends_on :mpi
  depends_on :fortran

  def install
    system "cmake", "-DCONFIG=gcc", "."
    system "make"
    bin.install "src/HPhi", "tool/corplot" => "corplot_hphi", "tool/fourier" => "fourier_hphi"
    doc.install "doc/jp/userguide_jp.pdf", "doc/en/userguide_en.pdf"
    pkgshare.install "samples"
  end

  test do
    system "false"
  end

  fails_with :clang do
    cause "HPhi does not support clang compiler."
  end
end
