class Mvmc < Formula
  desc "Solver for quantum lattice models based on many-variable VMC method"
  homepage "https://github.com/issp-center-dev/mVMC/releases"
  url "https://github.com/issp-center-dev/mVMC/releases/download/v1.0.0/mVMC-1.0.0.tar.gz"
  sha256 "f9a8098733d12a6e35fd5d1f308cb3d0e0946aa688487d63d93516e166794dc8"

  depends_on "cmake" => :build
  depends_on :mpi
  depends_on :fortran

  needs :openmp

  option "with-icc", "Build by Intel compiler"
  option "with-scalapack", "Build with ScaLAPACK support"
  depends_on "scalapack" => :optional

  def install
    args = std_cmake_args
    args.delete "-DCMAKE_BUILD_TYPE=None"
    args << "-DCMAKE_BUILD_TYPE=Release"
    if build.with? "scalapack"
      args << "-DUSE_SCALAPACK=ON"
      args << "-DSCALAPACK_LIBRARIES=-lscalapack"
    end

    if build.with? "icc"
      args << "-DCONFIG=intel"
    else
      args << "-DCONFIG=gcc"
    end

    system "cmake", ".", *args
    system "make"
    bin.install "src/mVMC/vmc.out", "src/mVMC/vmcdry.out", "src/ComplexUHF/UHF"
    bin.install "tool/fourier" => "fourier_mvmc", "tool/corplot" => "corplot_mvmc"
    doc.install "doc/jp/userguide_jp.pdf", "doc/en/userguide_en.pdf"
    pkgshare.install "sample"
  end

  test do
    system "true"
  end

end
