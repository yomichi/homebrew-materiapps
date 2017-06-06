class Openmx < Formula
  desc "Open source package for Material eXplorer"
  homepage "http://www.openmx-square.org/"
  url "http://www.openmx-square.org/openmx3.8.tar.gz"
  sha256 "36ee10d8b1587b25a2ca1d57f110111be65c4fb4dc820e6d93e1ed2b562634a1"
  version "3.8.3"

  resource "nondiff_patch" do
    url "http://www.openmx-square.org/bugfixed/17Mar08/patch3.8.3.tar.gz"
    sha256 "d30b08301966dec913b6b42acdce17b543f7f4f5098bb2668a8db1e6b9067570"
  end

  needs :openmp
  depends_on "fftw" => ["with-openmp"]
  depends_on :mpi => [:cc, :fort]

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    resource("nondiff_patch").stage {
      (buildpath/'source').install Dir["*"]
    }
    File.open(buildpath/"source"/"makefile", "r") do |f_in|
      buf = f_in.read
      buf.gsub!(/^\s*CC\s*=.*$/, "CC=mpicc -O3 -fopenmp\n")
      buf.gsub!(/^\s*FC\s*=.*$/, "FC=mpif90 -O3 -fopenmp\n")
      buf.gsub!(/^\s*LIB\s*=.*$/, "LIB=-lfftw3 -framework Accelerate -lblas -llapack -lpthread -lgfortran -lmpi_mpifh -lmpi\n")
      File.open(buildpath/"source"/"makefile", "w") do |f_out|
        f_out.write(buf)
      end
    end
    cd buildpath/"source"
    for file in ["Set_OLP_Kin.c", "Set_ProExpn_VNA.c"]
      File.open(file, "r") do |f_in|
        buf = f_in.read
        buf.gsub!(/^\s*inline /, "static inline ")
        File.open(file, "w") do |f_out|
          f_out.write(buf)
        end
      end
    end
    system "make -f makefile"

    bin.install "openmx"
    cd buildpath
    doc.install "openmx3.8.pdf"
    pkgshare.install "work"
  end

  test do
    system "#{bin}/openmx #{pkgshare}/work/Methene.dat"
  end
end
