export CVSROOT=/tools/CVSROOT/
export LM_LICENSE_FILE=2121@purple:/tools/licenses/syn_deepblue.lic:/tools/licenses/cadence.kadaos.dat:/tools/licenses/altera.dat:/tools/licenses/altera.06.May.2008.dat:/homes/istamoulis/actelLicense.dat

# Customize to your needs...
export PATH=/tools/target_IPPVShader/VShader-11R1.1/bin/LNx86bin:/tools/target_IPPVShader/VShader-11R1.1/bin:/tools/target_IPPVShader/VShader-11R1.1/bin/LNx86bin:/tools/target_IPPVShader/VShader-11R1.1/bin:/opt/sparc-linux-3.4.4/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/tools/sparc/sparc-elf/bin:/tools/sparc/sparc-uclinux/bin:/tools/sparc/sparc-linux/bin:/tools/licenses/SCL/linux/bin/:/tools/synopsys/Y-2006.06/amd64/syn/bin/:/tools/synopsys/pts_X2005.09SP3/amd64/syn/bin/:/tools/synopsys/Y-2006.06-SP1/bin/:/tools/cadence/ius-5.7/lnx86/tools/bin/:/tools/cadence/IUS82/tools.lnx86/inca/bin:/tools/cadence/IUS82/tools.lnx86/bin/:/tools/mips/bin:/tools/mentor/modelsim11.1/modelsim_ase/linux:/homes/cperivol/.rvm/bin:/tools/sparc/sparc-elf/bin:/tools/sparc/sparc-uclinux/bin:/tools/sparc/sparc-linux/bin:/tools/licenses/SCL/linux/bin/:/tools/synopsys/Y-2006.06/amd64/syn/bin/:/tools/synopsys/pts_X2005.09SP3/amd64/syn/bin/:/tools/synopsys/Y-2006.06-SP1/bin/:/tools/cadence/ius-5.7/lnx86/tools/bin/:/tools/cadence/IUS82/tools.lnx86/inca/bin:/tools/cadence/IUS82/tools.lnx86/bin/:/tools/mips/bin:/tools/mentor/modelsim11.1/modelsim_ase/linux:/homes/cperivol/.rvm/bin

export PATH=$PATH:/opt/Xilinx/SDK/2013.4/bin/lin64
# XLNX_ROOT=/opt/Xilinx/14.4
# XLNX_ROOT=/tools/Xilinx13.4
export PATH=$HOME/bin/:$PATH
export PATH=$PATH:/homes/cperivol/CodeSourcery/Sourcery_CodeBench_Lite_for_Xilinx_GNU_Linux/bin/:/homes/cperivol/Projects/u-boot-xlnx/tools/
export PATH=$PATH:$XLNX_ROOT/ISE_DS/ISE/bin/lin64
export PATH=$PATH:$XLNX_ROOT/ISE_DS/EDK/bin/lin64
export PATH=$PATH:$XLNX_ROOT/ISE_DS/common/bin/lin
export PATH=$PATH:$XLNX_ROOT/ISE_DS/PlanAhead/bin/
export PATH=$PATH:/opt/Xilinx/Vivado/2012.4/bin
# export PATH=$PATH:/opt/CodeSourcery/Sourcery_CodeBench_Lite_for_Xilinx_GNU_Linux/bin/
# export PATH=$PATH:/homes/gsidiropoulos/Projects/Xilinx/u-boot-xlnx/tools/
# export PATH=$PATH:/homes/gsidiropoulos/Projects/Xilinx/qemu-xarm/arm-softmmu/
export XILINX=$XLNX_ROOT/ISE_DS/ISE
export XILINX_EDK=$XLNX_ROOT/ISE_DS/EDK
export PATH=$PATH:/opt/Xilinx/SDK/2013.4/gnu/arm/lin/bin
export PATH=$PATH:/tools/cadence/ius-5.7/lnx86/tools/bin

# Cross compilers
export PATH="$PATH:/home/fakedrake/Projects/ThinkSilicon/xilinx-zynq-bootstrap/sources/gnu-tools-archive/GNU_Tools/bin/"

# Sparc criss compile
mount -l | grep /tools > /dev/null && export PATH=$PATH:/tools/sparc/sparc-linux/bin
