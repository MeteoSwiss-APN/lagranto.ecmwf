F77	= ${FORTRAN}
FFLAGS	= -O
OBJS	= lsl2rdf.o ${LAGRANTO}/lib/iotra.a  ${LAGRANTO}/lib/libcdfio.a ${LAGRANTO}/lib/libcdfplus.a
INCS	= ${NETCDF_INC}
LIBS	= ${NETCDF_LIB} 

.f.o: $*.f
	${F77} -c ${FFLAGS} ${INCS} $*.f

lsl2rdf:	$(OBJS)
	${F77} -o lsl2rdf $(OBJS) ${INCS} $(LIBS)
