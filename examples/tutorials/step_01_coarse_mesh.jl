using MPI
using T8code
using CBinding

# /* Builds cmesh of 6 tetrahedra that build up a unit cube.
#  * \param [in] comm   MPI Communicator to use.
#  * \return            The coarse mesh.
#  */
function t8_step1_build_tetcube_coarse_mesh(mpicomm)

    # /* Build a coarse mesh of 6 tetrahedral trees that form a cube.
    #  * You can modify the first parameter to build a cube with different
    #  * tree shapes, i.e. T8_ECLASS_QUAD for a unit square with 1 quadrilateral tree.
    #  * See t8_eclass.h, t8_cmesh.h for all possible shapes.
    #  * 
    #  * The second argument is the MPI communicator to use for this cmesh.
    #  * The remaining arguments are 3 flags that control
    #  *   do_bcast     - If non-zero only the root process will build the cmesh and will broadcast it to the other processes. The result is the same.
    #  *   do_partition - If non-zero the cmesh will be partitioned among the processes. If 0 each process has a copy of the whole cmesh.
    #  *   periodic     - If non-zero the cube will have periodic boundaries. That is, i.e. the left face is connected to the right face.
    #  */

    return c"t8_cmesh_new_hypercube"(c"T8_ECLASS_HEX", mpicomm, 0, 0, 0);
end

# /* Write vtk (or more accurately vtu) files of the cmesh.
#  * \param [in] cmesh    A coarse mesh.
#  * \param [in] prefix   A string that is used as a prefix of the output files.
#  * 
#  * This will create the file prefix.pvtu and the file prefix_0000.vtu.
#  * If the coarse mesh would be repartitioned, then it would write the .pvtu file
#  * and additionally one file prefix_MPIRANK.vtu per MPI rank.
#  */
function t8_step1_write_cmesh_vtk(cmesh, prefix)
    c"t8_cmesh_vtk_write_file"(cmesh, prefix, 1.0);
end

# /* Destroy a cmesh. This will free all allocated memory.
#  * \param [in] cmesh    A cmesh.
#  */
function t8_step1_destroy_cmesh(cmesh)
    c"t8_cmesh_destroy"(Ref(cmesh));
end

const prefix = "t8_step1_tetcube";

# /* Initialize MPI. This has to happen before we initialize sc or t8code. */
MPI.Init()
mpicomm = MPI.COMM_WORLD.val

# /* Initialize the sc library, has to happen before we initialize t8code. */
c"sc_init"(mpicomm, 1, 1, C_NULL, c"SC_LP_VERBOSE")

# /* Initialize t8code with log level SC_LP_PRODUCTION. See sc.h for more info on the leg levels. */
c"t8_init"(c"SC_LP_VERBOSE")

c"t8_global_productionf"(" [step 1] Hello, this is the step 1 example of t8code.\n");
c"t8_global_productionf"(" [step 1] In this example we build our first coarse mesh and output it to vtu files.\n");
c"t8_global_productionf"(" [step 1] \n");

# /* Build the coarse mesh */
cmesh = t8_step1_build_tetcube_coarse_mesh(mpicomm);

# /* Compute local and global number of trees. */
local_num_trees = c"t8_cmesh_get_num_local_trees"(cmesh);
global_num_trees = c"t8_cmesh_get_num_trees"(cmesh);

c"t8_global_productionf"(" [step 1] Created coarse mesh.\n");
c"t8_global_productionf"(" [step 1] Local number of trees:\t%i\n",local_num_trees);
c"t8_global_productionf"(" [step 1] Global number of trees:\t%li\n",global_num_trees);

t8_step1_write_cmesh_vtk(cmesh, prefix);
c"t8_global_productionf"(" [step 1] Wrote coarse mesh to vtu files: %s*\n",prefix);

t8_step1_destroy_cmesh(cmesh)
c"t8_global_productionf"(" [step 1] Destroyed coarse mesh.\n");

c"sc_finalize"()
