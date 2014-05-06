function sphere_voronoi_ ( )

%*****************************************************************************80
%
%% SPHERE_VORONOI_ displays the Voronoi polygons of the data.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    05 May 2014
%
%  Author:
%
%    Roberto Vergaray -- adapted from sphere_voroni_test02 by John Burkardt
%

    fprintf ( 1, '\nSPHERE_VORONOI\n' );

%
%   Aquire Ponts
%
    d_xyz = input('Enter a set of xyz-points: '  );
    if( isempty(d_xyz) )
        n = input('Enter the quantity of points to randomy generate\n (default is 50): ');
        if( isempty(n) ) %TODO: assert non-negative
            n = 50
        end
        seed = 123456789;
        [ d_xyz, seed ] = uniform_on_sphere01_map ( 3, n, seed );
    else
        [dim_num,n] = size(d_xyz);
        %TODO: assert dim_num = 3;
        if( eq(dim_num,3) )

            for j = 1 : n
                norm = sqrt ( sum ( d_xyz(1:dim_num,j).^2 ) );
                d_xyz(1:dim_num,j) = d_xyz(1:dim_num,j) / norm;
            end
        else
            d_xyz = transpose(d_xyz);
            [dim_num,n] = size(d_xyz);
            if( eq(dim_num,3) )

                for j = 1 : n
                    norm = sqrt ( sum ( d_xyz(1:dim_num,j).^2 ) );
                    d_xyz(1:dim_num,j) = d_xyz(1:dim_num,j) / norm;
                end
            else
                fprintf ( 1, '\nERROR\n' );
                return
            end
        end
    end

%
%   Compute the Delaunay triangulation.
%
    [ face_num, face ] = sphere_delaunay ( n, d_xyz );
%
%   For each Delaunay triangle, compute the normal vector, to get the
%   Voronoi vertex.
%
    v_xyz = voronoi_vertices ( n, d_xyz, face_num, face );
%
%   Compute the Voronoi vertex lists that define the Voronoi polygons.
%
    [ first, list ] = voronoi_polygons ( n, face_num, face );
    list_num = 2 * face_num;
%
%   Plot the polygons.
%
    clf
    hold on

    for i = 1 : n
        n1 = first(i);
        n2 = first(i+1) - 1;
        j = list(n1:n2);
        j = [ j; list(n1) ];
        h(i) = patch ( v_xyz(1,j), v_xyz(2,j), v_xyz(3,j), 'blue', ...
            'EdgeColor', 'r', 'LineWidth', 2.0, 'FaceAlpha', 0.9 );
    end

    plot3 ( d_xyz(1,:), d_xyz(2,:), d_xyz(3,:), 'r*' );

    axis equal
    xlabel ( '-- X --' );
    ylabel ( '-- Y --' );
    zlabel ( '-- Z --' );
    title ( 'Figure 1: Voronoi polygons using PATCH' );
    hold off

    return
end