# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Feram < Formula
  desc "feram: MD simulator for bulk and thin-film ferroelectrics"
  homepage "http://loto.sourceforge.net/feram/index.en.html"
  url "https://downloads.sourceforge.net/project/loto/feram/feram-0.26.04/feram-0.26.04.tar.xz"
  sha256 "d9e7ebd040631bb01998660ac726ca062a8b4a9efc3b06981e4ff40572a2ff13"

  needs :openmp
  depends_on :fortran
  depends_on "fftw" => ["with-openmp", "with-fortran"]

  def install
    configure_args = ["--prefix=#{prefix}"]
    configure_args << "--with-fft=fftw3_omp"
    configure_args << "FCFLAGS=-fopenmp"
    system "./configure", *configure_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test feram`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
